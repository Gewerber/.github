# 🔐 GitHub Secret Scanning Runbook

This runbook documents GitHub's native secret scanning and push protection for the public repositories in the **Gewerber** organization. It also records the verified configuration snapshot and provides safe operational checks for preventing future configuration drift.

---

## 1️⃣ Purpose and Scope

GitHub provides two complementary native controls:

| **Control** | **Purpose** |
|---|---|
| **Secret scanning** | Hosted detection of supported secrets in repository data, with security alerts for follow-up. |
| **Push protection** | Pre-push prevention that blocks a push containing a supported secret before the push is accepted. |

These controls reduce exposure and improve detection, but they do **not** replace credential rotation or incident response. A suspected or confirmed exposed credential must still be revoked or rotated and investigated through the applicable security process.

**Scope:** the seven public repositories owned by the **Gewerber** organization. The four private repositories require a paid GitHub product and are outside this runbook's current Free-plan scope.

---

## 2️⃣ Verified Organization State

**Re-audited on 2026-09-25.** The snapshot was verified through the GitHub REST API using `GET /repos/Gewerber/<repo>` and each repository's `.security_and_analysis` data.

| **Repository** | **Secret scanning** | **Push protection** |
|---|---|---|
| `.github` | `enabled` | `enabled` |
| `gewerber-app` | `enabled` | `enabled` |
| `gewerber-backend` | `enabled` | `enabled` |
| `gewerber-backend-stubs` | `enabled` | `enabled` |
| `gewerber-docs` | `enabled` | `enabled` |
| `gewerber-examples` | `enabled` | `enabled` |
| `gewerber-mcp` | `enabled` | `enabled` |

**Organization:** `Gewerber`  
**Type:** Organization  
**Plan:** `free`

The premise in [issue #20](https://github.com/Gewerber/.github/issues/20)—that the other six public repositories have no secret scanning at all—is now stale. A read-only API re-audit confirms that both controls are already enabled on all seven public repositories. The remaining work is to preserve this verified state, document the operating procedure, and detect future drift.

This table is a point-in-time snapshot, not a guarantee of future configuration. Run the [secret scanning audit script](scripts/audit-secret-scanning.sh) to refresh the result and detect drift across the organization's current public repositories.

The organization-level defaults for **new** repositories are a separate control plane and are **currently disabled for both controls** — see section 4.

---

## 3️⃣ Defense-in-Depth Layers

| **Layer** | **Function** | **Coverage and limitations** |
|---|---|---|
| **GitHub push protection** | Pre-push prevention that blocks supported secrets before a push is accepted. | Enabled on all seven public repositories. |
| **GitHub native secret scanning** | Hosted secret detection and security alerts. | Enabled on all seven public repositories. |
| **`gewerber-mcp` TruffleHog CI** | Independent check for verified secrets in the checked-out working tree. | Runs in `gewerber-mcp` only; absent from the other six public repositories. It does not scan Git history and fails only on verified secrets. |
| **`scripts/audit-secret-scanning.sh`** | Audits the organization control plane for configuration drift. | **This is not a content scanner.** It checks repository settings only. |

### 🧪 Existing TruffleHog CI

The workflow at `gewerber-mcp/.github/workflows/secret-scan.yml`:

- Runs on pushes to `main` and `develop`, and on all pull requests.
- Grants only `contents: read` permission and uses a concurrency group.
- Uses `actions/checkout@v7` with `fetch-depth: 1`.
- Removes the checked-out `.git` directory and then runs `trufflesecurity/trufflehog:latest filesystem /repo --only-verified --no-update` in Docker.

Because the workflow deletes `.git` and uses TruffleHog's `filesystem` mode, it scans the **checked-out working tree only, not Git history**. The `--only-verified` setting means the job fails only for verified secrets, so false positives are tolerated.

The workflow's header comment says it is “for private repositories,” although `gewerber-mcp` is public. This is a documentation inconsistency. Correcting the comment and adding history scanning or checkout hardening are separate follow-up work and are not part of this change.

---

## 4️⃣ Organization Defaults for New Public Repositories

### 🚨 Open Gap

**Verified 2026-09-26 against the live API.** Both organization-level defaults are currently **`false`**:

```json
{"secret_scanning_enabled_for_new_repositories": false,
 "secret_scanning_push_protection_enabled_for_new_repositories": false}
```

The operational consequence: **a newly created public repository would not get secret scanning or push protection by default.** This is a real, still-open gap for [issue #20](https://github.com/Gewerber/.github/issues/20) and requires an organization owner action.

This does **not** contradict section 2. All seven existing public repositories have both controls enabled, because they were enabled individually. The disabled default only affects **future** repositories, and the organization default is a separate control plane from the per-repository settings that the audit script checks.

Check the current state at any time with this read-only command:

```bash
gh api orgs/Gewerber --jq '[.secret_scanning_enabled_for_new_repositories, .secret_scanning_push_protection_enabled_for_new_repositories] | @tsv'
```

The audit script also surfaces these values as a read-only advisory after its per-repository summary, and `--fix` does not change them. The advisory is informational only and never affects the script's exit code; see section 6.

### 🛠 Owner procedure

The organization owner should configure the defaults in the GitHub organization settings:

1. Sign in as a **Gewerber organization owner**.
2. Open `https://github.com/organizations/Gewerber/settings/security_analysis`.
3. Go to **Code security**.
4. Go to **Secret scanning**.
5. Enable both **Secret scanning** and **Push protection** for new repositories. These settings correspond to `secret_scanning_enabled_for_new_repositories` and `secret_scanning_push_protection_enabled_for_new_repositories`.
6. Save the settings.

| **Property** | **Operational meaning** |
|---|---|
| **Scope** | Applies only to **new** repositories. It does not retroactively change existing repositories. |
| **Evidence of existing state** | Does not prove that any existing repository has the controls enabled. Use the audit script for that check. |
| **API support** | Readable via `GET /orgs/{org}` and settable via `PATCH /orgs/{org}`. The UI path above remains the normal way to change them. |
| **Deprecation notice** | GitHub marks both fields as closing down in favour of code security configurations. They are still functional today; treat code security configurations as the long-term direction. |
| **Required access** | Organization owner. |

---

## 5️⃣ Per-Repository Fallback (UI)

If an existing public repository does not match the required state, an authorized maintainer can use the per-repository settings page:

1. Open `https://github.com/Gewerber/<repo>/settings/security_analysis`.
2. Go to **Code security**.
3. Enable both **Secret scanning** and **Push protection**.
4. Save the settings.
5. Re-run the read-only audit to confirm the result.

**Required privilege:** repository admin, organization owner, or security manager.

**Private-repository warning:** private repositories do not receive these native controls on the organization's current Free plan. They require the paid GitHub Secret Protection / Code Security product and are outside this runbook's scope.

---

## 6️⃣ Verification and Automation

### 🔍 Authentication and read-only verification

Authenticate the GitHub CLI first, then run the read-only audit:

```bash
gh auth status
./scripts/audit-secret-scanning.sh
```

With no arguments, the script enumerates all current public repositories in `Gewerber`, prints a status table, a summary, and a read-only advisory about the organization-level defaults for new repositories, and makes no configuration changes.

For a one-repository spot check, for example:

```bash
gh api repos/Gewerber/.github --jq '{secret_scanning: .security_and_analysis.secret_scanning.status, push_protection: .security_and_analysis.secret_scanning_push_protection.status}'
```

### 🏢 Organization-level defaults are a separate, advisory check

The organization defaults for **new** repositories are a different control plane from the per-repository settings audited above. The script reports them as an **advisory block** printed after the per-repository summary, in both the read-only and `--fix` modes:

```text
Organization defaults for NEW repositories (read-only, not remediated by --fix):
  Secret scanning for new repositories:  disabled
  Push protection for new repositories:  disabled
  See SECRET_SCANNING.md — enabling these is an organization owner action.
```

Those two `disabled` lines correspond to `secret_scanning_enabled_for_new_repositories` and `secret_scanning_push_protection_enabled_for_new_repositories` being `false` on `GET /orgs/{org}`. The script renders each value as `enabled`, `disabled`, or `unavailable`; `unavailable` means the field was missing or the query failed, and is printed with a note.

**The advisory never affects the outcome.** Specifically:

- The per-repository table, the **Summary** line, and the **exit code** reflect **per-repository** state only. A `disabled` organization default is reported but never fails the run.
- `--fix` never writes the organization defaults. Remediation stays strictly per-repository.
- The default only describes what a **future** repository would inherit. All seven existing public repositories are enabled and remain compliant regardless of it.

To check the same values without running the full audit:

```bash
gh api orgs/Gewerber --jq '[.secret_scanning_enabled_for_new_repositories, .secret_scanning_push_protection_enabled_for_new_repositories] | @tsv'
```

This currently returns `false` for both fields (verified 2026-09-26); see the open gap in section 4. Changing them is an **organization owner** action, either in the settings UI or by an owner calling:

```http
PATCH /orgs/{org}
```

```json
{"secret_scanning_enabled_for_new_repositories": true,"secret_scanning_push_protection_enabled_for_new_repositories": true}
```

`PATCH /orgs/{org}` requires an organization owner, so it cannot be performed with a workflow's default `GITHUB_TOKEN`, for the same reason as the per-repository `--fix` path. Both fields carry GitHub's closing-down notice in favour of code security configurations, but they remain functional.

### 🛠 Guarded remediation

```bash
./scripts/audit-secret-scanning.sh --fix
```

`--fix` performs a guarded remediation after the initial audit. Its safeguards are:

- Requires an interactive TTY; there is no non-interactive bypass.
- Requires the exact confirmation `ENABLE <count>`, where the count is the number of drifted repositories.
- Does not proceed if the initial audit contains API errors.
- Re-checks each repository immediately before any write.
- Refuses repositories that are not confirmed public and non-private, or whose setting fields are missing or unavailable.
- PATCHes only repositories that pass all checks and requires a drifted, explicitly disabled setting.
- Re-runs the full audit afterward; the post-remediation audit determines the final exit status.

Display usage information with:

```bash
./scripts/audit-secret-scanning.sh --help
```

### 🚦 Exit codes

| **Exit code** | **Meaning** |
|---|---|
| `0` | The read-only audit is compliant, `--fix` found no drift, remediation completed with a compliant post-audit, or `--help` completed successfully. |
| `1` | Configuration drift or repository/API errors remain. For `--fix`, the post-remediation audit is not compliant. |
| `2` | Usage, authentication, interactive-confirmation, enumeration, or other fatal preflight errors prevent the requested operation. |

### 🔐 Authentication and permission boundary

The underlying authorized per-repository operation is:

```http
PATCH /repos/{owner}/{repo}
```

```json
{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}
```

**Privileges for `--fix`:** repository admin, organization owner, or security manager. The script uses the GitHub CLI's existing authentication; **no token is passed as an argument or stored in this repository**.

GitHub Actions' default `GITHUB_TOKEN` has no `administration` permission, so a workflow in any repository cannot use that token to flip these settings. Enforcement automation therefore requires an owner-run script or a GitHub App or personal access token with organization admin access. Run remediation only with an authorized operator account.

---

## 7️⃣ Known Gaps and Plan Boundaries

### Optional secret scanning controls

The following optional controls were `disabled` across all seven public repositories in the 2026-09-25 re-audit:

| **Setting** | **Verified status** | **Issue #20 criteria** | **Next step** |
|---|---|---|---|
| `secret_scanning_non_provider_patterns` | `disabled` | Not included in the pass/fail criteria. | Make a separate enablement decision. |
| `secret_scanning_validity_checks` | `disabled` | Not included in the pass/fail criteria. | Make a separate enablement decision. |

This change does not enable either optional control. Enabling them requires a separate security decision and is outside issue #20's current acceptance criteria.

### Private repositories and plan boundary

| **Private repository** | **Current scope** |
|---|---|
| `gewerber-app-commercial` | Out of scope on the Free plan. |
| `gewerber-backend-commercial` | Out of scope on the Free plan. |
| `gewerber-business` | Out of scope on the Free plan. |
| `gewerber-website` | Out of scope on the Free plan. |

Native secret scanning and push protection are free for public repositories. The four private repositories require the paid GitHub Secret Protection / Code Security product and are not part of this Free-plan runbook.

Dependabot security updates were also recorded as `disabled`, but their enablement is a separate topic from issue #20.

---

## 8️⃣ Follow-Ups

**None of the following changes is done by this change:**

- **Enable the organization defaults for new repositories** — verified `false` for both controls on 2026-09-26, so a **newly created public repository would start without either control** (**organization owner action**). Settable via `PATCH /orgs/{org}` by an owner, or through the settings UI; see section 4. The seven existing public repositories are unaffected and already compliant.
- Decide whether to enable `secret_scanning_non_provider_patterns`.
- Add TruffleHog-equivalent working-tree scanning to the other six public repositories.
- Update `gewerber-mcp`'s secret-scan workflow to scan Git history and set `persist-credentials: false` on checkout.
- Correct the `gewerber-mcp` workflow header that inaccurately says “for private repositories.”

---

## 9️⃣ Related Documents

- **[Security Policy](SECURITY.md)**
- **[Organization Structure](ORGANIZATION.md)**
- **[Secret scanning audit script](scripts/audit-secret-scanning.sh)**
