# TODO — Gewerber security sweep

Items belonging to [#20](https://github.com/Gewerber/.github/issues/20) are part of the native secret-scanning and push-protection sweep.

- [x] Audit all 7 public repos for secret scanning + push protection (both already `enabled` as of 2026-09-25)
- [x] Add `scripts/audit-secret-scanning.sh` (read-only audit by default; guarded `--fix`)
- [x] Add `SECRET_SCANNING.md` operations runbook
- [x] Cross-link the runbook from `SECURITY.md` and `ORGANIZATION.md`
- [x] Verify the audit script (`bash -n`, live dry run: 7/7 compliant) and the docs (links resolve)
- [ ] Open the PR into `develop` with `Refs #20` and add the `agent:pr-opened` label
- [ ] Record the PR number here once opened
- [ ] Owner: enable org defaults for NEW public repos at org Settings → Code security → Secret scanning (UI-only, no API) — leave this `[ ]`; it cannot be done from code
- [ ] Owner: decide whether to enable `secret_scanning_non_provider_patterns` and `secret_scanning_validity_checks` (separate decision, not part of #20)
- [ ] Follow-up issue: extend TruffleHog tree scanning to the other 6 public repos and scan git history in `gewerber-mcp` (not part of #20)
