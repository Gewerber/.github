# TODO — Gewerber security sweep

Items belonging to [#20](https://github.com/Gewerber/.github/issues/20) are part of the native secret-scanning and push-protection sweep.

- [x] Audit all 7 public repos for secret scanning + push protection (both already `enabled` as of 2026-09-25)
- [x] Add `scripts/audit-secret-scanning.sh` (read-only audit by default; guarded `--fix`)
- [x] Add `SECRET_SCANNING.md` operations runbook
- [x] Cross-link the runbook from `SECURITY.md` and `ORGANIZATION.md`
- [x] Verify the audit script (`bash -n`, live dry run: 7/7 compliant) and the docs (links resolve)
- [x] Open the PR into `develop` with `Refs #20` and add the `agent:pr-opened` label — [#25](https://github.com/Gewerber/.github/pull/25)
- [x] Record the PR number here once opened — [#25](https://github.com/Gewerber/.github/pull/25)
- [ ] Owner: enable org defaults for NEW public repos — currently `false` for both, so a new public repo would not inherit them. Org Settings → Code security → Secret scanning, or `PATCH /orgs/{org}` (requires org owner; not reachable by `GITHUB_TOKEN`). Leave this `[ ]`; it needs an owner
- [ ] Owner: decide whether to enable `secret_scanning_non_provider_patterns` and `secret_scanning_validity_checks` (separate decision, not part of #20)
- [ ] Follow-up issue: extend TruffleHog tree scanning to the other 6 public repos and scan git history in `gewerber-mcp` (not part of #20)
