#!/usr/bin/env bash
set -euo pipefail

# The explicit default is a guard against accidentally targeting another org.
# A non-empty GEWERBER_OWNER value is supported for controlled automation.
OWNER="${GEWERBER_OWNER:-Gewerber}"
readonly OWNER

MODE="audit"
REPO_NAMES=()
REPO_PRIVATE=()
REPO_VISIBILITIES=()
SECRET_SCANNING_STATUSES=()
PUSH_PROTECTION_STATUSES=()
ROW_STATUSES=()
ROW_ERRORS=()
TOTAL_CHECKED=0
COMPLIANT_COUNT=0
DRIFTED_COUNT=0
ERROR_COUNT=0

usage() {
    printf '%s\n' \
        'Usage: scripts/audit-secret-scanning.sh [--fix|--help]' \
        '' \
        'Audits every public repository in the Gewerber organization for:' \
        '  - GitHub secret scanning' \
        '  - GitHub secret scanning push protection' \
        '' \
        'With no argument, performs a read-only audit (the safe default).' \
        '--fix enables drifted controls, but only after an exact interactive confirmation.' \
        '--help  shows this help text.'
}

parse_args() {
    MODE="audit"

    if (( $# == 0 )); then
        return 0
    fi

    if (( $# != 1 )); then
        printf '%s\n' 'Error: provide at most one argument.' >&2
        usage >&2
        return 2
    fi

    case "$1" in
        --fix)
            MODE="fix"
            ;;
        --help)
            MODE="help"
            ;;
        *)
            printf 'Error: unknown argument: %s\n' "$1" >&2
            usage >&2
            return 2
            ;;
    esac
}

preflight() {
    if ! command -v gh >/dev/null 2>&1; then
        printf '%s\n' 'Error: the GitHub CLI (gh) is required but was not found on PATH.' >&2
        return 2
    fi

    if ! gh auth status >&2; then
        printf '%s\n' 'Error: gh authentication is missing, invalid, or expired.' >&2
        return 2
    fi
}

list_public_repos() {
    local repos_output

    # Intentionally do not exclude archived or forked repositories. Private repositories
    # are excluded because this audit and any remediation are limited to public repos.
    # Capture first: an empty or failed enumeration must never be reported as "all clear".
    if ! repos_output="$(gh repo list "$OWNER" --visibility public --limit 10000 --json name,isPrivate,visibility --jq '.[] | select(.isPrivate == false and .visibility == "PUBLIC") | .name')"; then
        printf 'Error: failed to enumerate public repositories for %s.\n' "$OWNER" >&2
        return 2
    fi

    if [[ ! "$repos_output" =~ [^[:space:]] ]]; then
        printf 'Error: no public repositories were found for %s; refusing to report success.\n' "$OWNER" >&2
        return 2
    fi

    # Sort the captured names so both tables and their exit conditions are deterministic.
    printf '%s\n' "$repos_output" | LC_ALL=C sort
}

fetch_repo() {
    local repo="$1"

    gh api "repos/${OWNER}/${repo}" --jq '[.private, .visibility, (.security_and_analysis.secret_scanning.status // "unavailable"), (.security_and_analysis.secret_scanning_push_protection.status // "unavailable")] | @tsv'
}

audit() {
    local repo_list="$1"
    local sorted_repos=""
    local repo=""
    local api_output=""
    local is_private=""
    local visibility=""
    local secret_scanning=""
    local push_protection=""
    local row_status=""
    local row_error=""
    local index=0
    local -i total=0
    local -i compliant=0
    local -i drifted=0
    local -i errors=0

    REPO_NAMES=()
    REPO_PRIVATE=()
    REPO_VISIBILITIES=()
    SECRET_SCANNING_STATUSES=()
    PUSH_PROTECTION_STATUSES=()
    ROW_STATUSES=()
    ROW_ERRORS=()

    if ! sorted_repos="$(printf '%s\n' "$repo_list" | LC_ALL=C sort)"; then
        printf '%s\n' 'Fatal error: failed to sort the captured repository list.' >&2
        return 2
    fi

    while IFS= read -r repo; do
        [[ -n "$repo" ]] || continue

        row_status="DRIFT"
        row_error=""
        is_private="unavailable"
        visibility="unavailable"
        secret_scanning="unavailable"
        push_protection="unavailable"

        if ! api_output="$(fetch_repo "$repo")"; then
            row_status="ERROR"
            row_error="GitHub API request failed; repository was not classified as safe"
        else
            IFS=$'\t' read -r is_private visibility secret_scanning push_protection <<< "$api_output"
            is_private="${is_private:-unavailable}"
            visibility="${visibility:-unavailable}"
            secret_scanning="${secret_scanning:-unavailable}"
            push_protection="${push_protection:-unavailable}"
            # The organization list and repository API can use different visibility casing.
            # Canonicalize the enum so only the canonical PUBLIC value can pass.
            visibility="${visibility^^}"

            # Fail closed: both controls must be exactly enabled, and the repository
            # must still be a public, non-private repository. Missing values never pass.
            if [[ "$is_private" == "false" && "$visibility" == "PUBLIC" && "$secret_scanning" == "enabled" && "$push_protection" == "enabled" ]]; then
                row_status="OK"
                compliant=$((compliant + 1))
            else
                row_status="DRIFT"
                drifted=$((drifted + 1))
            fi
        fi

        if [[ "$row_status" == "ERROR" ]]; then
            errors=$((errors + 1))
        fi

        REPO_NAMES+=("$repo")
        REPO_PRIVATE+=("$is_private")
        REPO_VISIBILITIES+=("$visibility")
        SECRET_SCANNING_STATUSES+=("$secret_scanning")
        PUSH_PROTECTION_STATUSES+=("$push_protection")
        ROW_STATUSES+=("$row_status")
        ROW_ERRORS+=("$row_error")
        total=$((total + 1))
    done <<< "$sorted_repos"

    printf '\n'
    printf '%-40s %-18s %-20s %s\n' 'REPOSITORY' 'SECRET SCANNING' 'PUSH PROTECTION' 'STATUS'
    printf '%-40s %-18s %-20s %s\n' '----------------------------------------' '------------------' '--------------------' 'STATUS'

    for (( index = 0; index < total; index++ )); do
        printf '%-40s %-18s %-20s %s\n' \
            "${REPO_NAMES[$index]}" \
            "${SECRET_SCANNING_STATUSES[$index]}" \
            "${PUSH_PROTECTION_STATUSES[$index]}" \
            "${ROW_STATUSES[$index]}"
    done

    if (( errors > 0 )); then
        printf '%s\n' 'Errors:'
        for (( index = 0; index < total; index++ )); do
            if [[ -n "${ROW_ERRORS[$index]}" ]]; then
                printf '  - %s: %s\n' "${REPO_NAMES[$index]}" "${ROW_ERRORS[$index]}"
            fi
        done
    fi

    TOTAL_CHECKED=$total
    COMPLIANT_COUNT=$compliant
    DRIFTED_COUNT=$drifted
    ERROR_COUNT=$errors

    printf 'Summary: total checked=%d compliant=%d drifted=%d errors=%d\n' \
        "$TOTAL_CHECKED" "$COMPLIANT_COUNT" "$DRIFTED_COUNT" "$ERROR_COUNT"

    if (( drifted > 0 || errors > 0 )); then
        return 1
    fi

    return 0
}

format_org_default() {
    local value="${1:-}"

    # gh api --jq renders the booleans as true/false. Anything else, including a
    # missing field, is reported as unavailable rather than guessed at.
    case "$value" in
        true)
            printf '%s' 'enabled'
            ;;
        false)
            printf '%s' 'disabled'
            ;;
        *)
            printf '%s' 'unavailable'
            ;;
    esac
}

# Read-only, informational advisory about the organization-level defaults that
# apply to repositories created from now on.
#
# This advisory is deliberately independent of pass/fail and of the exit code.
# What this script audits and remediates is per-repository enforcement; the org
# defaults are a separate, owner-level concern for future repositories. A
# disabled default is therefore reported but never fails the run: all public
# repositories being compliant is a passing result regardless of these values.
#
# --fix never writes them either. Remediation stays strictly per-repository.
# Changing an org default requires organization owner privileges, via the
# organization settings UI or `PATCH /orgs/{org}`. That endpoint is not
# reachable by a workflow's GITHUB_TOKEN, which has no `administration`
# permission, so it is left to an owner either way. See SECRET_SCANNING.md.
org_defaults() {
    local defaults_output=""
    local raw_secret_scanning=""
    local raw_push_protection=""

    printf 'Organization defaults for NEW repositories (read-only, not remediated by --fix):\n'

    # gh's own stderr is suppressed so the advisory reads as one coherent block;
    # any failure is reported through the advisory itself instead. The query is
    # wrapped in `|| true` by the caller, so a failure can never abort the run or
    # alter the exit code.
    #
    # The `type == "boolean"` test is deliberate and must not be replaced by
    # `//`: jq's alternative operator treats `false` as empty, so
    # `false // "unavailable"` yields "unavailable" and a genuinely disabled
    # default would be misreported as unknown. Only a missing or null field
    # should become "unavailable".
    if ! defaults_output="$(gh api "orgs/${OWNER}" --jq '[(.secret_scanning_enabled_for_new_repositories | if type == "boolean" then tostring else "unavailable" end), (.secret_scanning_push_protection_enabled_for_new_repositories | if type == "boolean" then tostring else "unavailable" end)] | @tsv' 2>/dev/null)"; then
        printf '  Secret scanning for new repositories:  unavailable\n'
        printf '  Push protection for new repositories:  unavailable\n'
        printf '  Note: the organization defaults query failed; informational only, exit code unaffected.\n'
        return 0
    fi

    IFS=$'\t' read -r raw_secret_scanning raw_push_protection <<< "$defaults_output"

    printf '  Secret scanning for new repositories:  %s\n' "$(format_org_default "$raw_secret_scanning")"
    printf '  Push protection for new repositories:  %s\n' "$(format_org_default "$raw_push_protection")"
    printf '  See SECRET_SCANNING.md — enabling these is an organization owner action.\n'

    return 0
}

confirm() {
    local drift_count="$1"
    local expected=""
    local confirmation=""

    # This guard has no non-interactive override: writes require a human at a TTY
    # to type an exact, drift-specific confirmation string.
    if [[ ! -t 0 ]]; then
        printf '%s\n' 'Error: --fix requires an interactive TTY; no bypass is available.' >&2
        return 2
    fi

    expected="ENABLE ${drift_count}"
    printf 'Type ENABLE %d to continue: ' "$drift_count"
    if ! IFS= read -r confirmation; then
        printf '\n%s\n' 'Error: confirmation could not be read; no changes were made.' >&2
        return 2
    fi

    if [[ "$confirmation" != "$expected" ]]; then
        printf '\n%s\n' 'Error: confirmation did not match exactly; no changes were made.' >&2
        return 2
    fi
}

setting_is_explicit() {
    local value="${1:-}"

    [[ -n "$value" && "$value" != "unavailable" && "$value" != "null" ]]
}

remediate() {
    local repo_list="$1"
    local repo=""
    local current=""
    local recheck_private=""
    local recheck_visibility=""
    local recheck_secret_scanning=""
    local recheck_push_protection=""
    local index=0
    local postcondition_status=0
    local -i fix_successes=0
    local -i fix_errors=0

    printf 'Drifted repositories (%d):\n' "$DRIFTED_COUNT"
    for (( index = 0; index < TOTAL_CHECKED; index++ )); do
        if [[ "${ROW_STATUSES[$index]}" == "DRIFT" ]]; then
            printf '  - %s: secret scanning=%s, push protection=%s\n' \
                "${REPO_NAMES[$index]}" \
                "${SECRET_SCANNING_STATUSES[$index]}" \
                "${PUSH_PROTECTION_STATUSES[$index]}"
        fi
    done

    if ! confirm "$DRIFTED_COUNT"; then
        return 2
    fi

    for (( index = 0; index < TOTAL_CHECKED; index++ )); do
        if [[ "${ROW_STATUSES[$index]}" != "DRIFT" ]]; then
            continue
        fi

        repo="${REPO_NAMES[$index]}"

        # Re-fetch immediately before any write. Scope and field checks
        # fail closed if repository state changed after the initial audit.
        if ! current="$(fetch_repo "$repo")"; then
            printf 'SKIPPED: %s: recheck API request failed; counted as an error; no write attempted.\n' "$repo" >&2
            fix_errors=$((fix_errors + 1))
            continue
        fi

        IFS=$'\t' read -r recheck_private recheck_visibility recheck_secret_scanning recheck_push_protection <<< "$current"
        recheck_private="${recheck_private:-unavailable}"
        recheck_visibility="${recheck_visibility:-unavailable}"
        recheck_secret_scanning="${recheck_secret_scanning:-unavailable}"
        recheck_push_protection="${recheck_push_protection:-unavailable}"
        recheck_visibility="${recheck_visibility^^}"

        if [[ "$recheck_private" != "false" || "$recheck_visibility" != "PUBLIC" ]]; then
            printf 'SKIPPED: %s: repository is not confirmed public and non-private; counted as an error.\n' "$repo" >&2
            fix_errors=$((fix_errors + 1))
            continue
        fi

        if ! setting_is_explicit "$recheck_secret_scanning" || ! setting_is_explicit "$recheck_push_protection"; then
            printf 'SKIPPED: %s: a setting status is missing or unavailable; counted as an error.\n' "$repo" >&2
            fix_errors=$((fix_errors + 1))
            continue
        fi

        if [[ "$recheck_secret_scanning" != "disabled" && "$recheck_push_protection" != "disabled" ]]; then
            printf 'SKIPPED: %s: neither control is currently disabled; counted as an error.\n' "$repo" >&2
            fix_errors=$((fix_errors + 1))
            continue
        fi

        # Enabling these controls requires org owner, security manager, or repo admin
        # privileges. The script uses gh's existing authentication; no token is ever
        # passed as an argument or stored in this repository.
        if printf '%s' '{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}' \
            | gh api --method PATCH "repos/${OWNER}/${repo}" --input - --silent; then
            printf 'ENABLED: %s\n' "$repo"
            fix_successes=$((fix_successes + 1))
        else
            printf 'FAILED: %s: GitHub API write failed; counted as an error.\n' "$repo" >&2
            fix_errors=$((fix_errors + 1))
        fi
    done

    printf 'Fix result: requested=%d succeeded=%d errors=%d\n' \
        "$DRIFTED_COUNT" "$fix_successes" "$fix_errors"

    # The full audit, not the PATCH responses or fix counters, determines final status.
    printf '%s\n' 'Post-remediation audit:'
    audit "$repo_list" || postcondition_status=$?

    return "$postcondition_status"
}

main() {
    local repo_list=""
    local audit_status=0

    if ! parse_args "$@"; then
        return 2
    fi

    if [[ "$MODE" == "help" ]]; then
        usage
        return 0
    fi

    if ! preflight; then
        return 2
    fi

    if ! repo_list="$(list_public_repos)"; then
        return 2
    fi

    if [[ "$MODE" == "audit" ]]; then
        # No argument means read-only: this is deliberately the safe default.
        audit "$repo_list" || audit_status=$?
        # Informational only; it can never change the exit code.
        org_defaults || true
        return "$audit_status"
    fi

    # audit() returns 1 both for API errors and for drift. Drift is precisely
    # what --fix exists to repair, so the status alone must not short-circuit
    # the remediation path; the ERROR_COUNT check below separates the two cases.
    audit "$repo_list" || audit_status=$?
    if (( audit_status == 2 )); then
        return 2
    fi

    # Printed for both modes, after the audit, and independent of the outcome.
    org_defaults || true

    # API errors block remediation even though drift does not: a partially
    # visible organization is not a safe basis for writing, and a repository
    # that failed to be classified is not a repository --fix may touch.
    if (( ERROR_COUNT > 0 )); then
        printf '%s\n' 'Fix not attempted because the audit contained API errors.' >&2
        return 1
    fi

    if (( DRIFTED_COUNT == 0 )); then
        printf '%s\n' 'No drift detected; no changes were needed.'
        return 0
    fi

    remediate "$repo_list"
}

main "$@"
