# Threat model v0.01

Status: initial model; review when routes, adapters or deployment change. Dependencies: security-baseline, tenancy, file-storage and deployment. v0.01 data is fictional but controls must carry into production.

## Assets and actors

Assets: future charity fundraising/contact data; credentials/sessions/MFA; native money and deadline integrity; files/exports/backups; audit history; tenant routing and availability. Actors: legitimate users, malicious/compromised tenant user, unauthenticated attacker, exceptional service operator, coding agent, dependency attacker. Trust boundaries: browser/server, proxy/server, auth/tenant context, control/tenant DBs, runtime/operator, metadata/storage, primary/off-site recovery.

| Threat | Control | Verification |
| --- | --- | --- |
| Tenant ID/record spoofing | session membership, fail-closed routing, restricted DB roles | altered URLs/actions and direct wrong-DB connections denied |
| Shared state/cache leaks | immutable request context, tenant/permission keys | concurrent A/B requests with same record IDs |
| File/export path guessing | private tenant prefixes, parent policy, opaque keys | cross-tenant download/temp/expired export and traversal tests |
| Stolen privileged session | MFA, expiry, recent reauth, revocation | enrolment/session-state bypass and offboarding tests |
| CSRF/XSS/SQL injection | library protections, origin checks, escaped notes, parameters | malicious notes/origins/filters do not execute or mutate |
| Upload malware/zip bomb/disk fill | private storage, allowlist/signature/path checks, streaming bounds, deployment-appropriate inspection, quotas/alerts | oversized stream, interrupted upload and configured-scanner failure cases; no scanner product prerequisite |
| CSV damage/formula injection | full-file validation, atomic import, safe text export | malformed CSV leaves counts unchanged; spreadsheet formula text escaped |
| Duplicate awards/lost edits | uniqueness, transactions, idempotency, version checks | parallel grant conversion and stale edit tests |
| FX/date corruption | Decimal strings, immutable FY/rate revisions, date-only helpers | missing rate, year revision, timezone/DST tests |
| Insider/operator overreach | no superuser CRM UI, individual constrained access, reasons/audit | support-access drill and expired credential verification |
| Backup/restore leakage | tenant sets, encryption, destination checks | A restore cannot overwrite B; keys outside repository |
| Host-specific hidden dependency | portable Compose/config, no managed-service calls | clean-host/offline-runtime installation test |
| Dependency compromise | normal lock, trusted packages, review/audit, non-root image | release dependency/image checks |
| Real-data development contamination | synthetic-only policy, seed guard, no production credentials | fixture review, repository scan and operator checklist |
| Historical record loss | organisation-controlled retention; no age-based CRM/audit purge; cleanup restricted to technical artefacts | advance clock beyond seven years; retained records, audit, links and attachments remain usable and exportable |

## Residual risks and gates

One VPS means shared outage/host-compromise risk; a privileged host operator can technically access multiple databases/files. Do not imply that database isolation eliminates this. Limit access, log it and maintain off-host recovery. App process compromise may expose configured tenant connections; use least privilege and rapid credential rotation. Provenance cannot be established merely by a synthetic banner; human handling rules remain necessary.

v0.01 must verify tenant isolation, authorisation, long-term history and monetary/date integrity. v0.05 requires production HTTPS/MFA enforcement, documented deployment-appropriate upload controls, tested provisioning/migration failure recovery, log/backup alerts and privacy incident drills. Where scanning is configured, test its failure behaviour. Record unresolved issues with severity, responsible maintainer, mitigation and release gate in the project documentation.
