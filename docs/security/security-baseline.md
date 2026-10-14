# Security baseline

Dependencies: tenancy, deployment, ADR-006/007/008. Mandatory controls; v0.01 tests foundations with synthetic data, v0.05 supplies production evidence. No assertion of certification or legal compliance merely because this document exists.

## Role policy

| Capability | Owner | Administrator | Fundraiser | Read-only |
| --- | --- | --- | --- | --- |
| View/search/calendar/download permitted documents | Yes | Yes | Yes | Yes |
| Create/edit/archive ordinary CRM records, lifecycle actions | Yes | Yes | Yes | No |
| Correct terminal outcomes/reopen grants | Yes | Yes | No | No |
| Settings, FY/FX, CSV import, bulk/full export, tenant audit | Yes | Yes | No | No |
| Invite/deactivate/change non-owner roles | Yes | Yes | No | No |
| Ownership transfer/service-level settings | Yes | No | No | No |
| Permanent privacy erasure | controlled procedure | controlled procedure | No | No |

Administrators cannot grant Owner or modify/deactivate the Owner. Keep exactly one active Owner; transfer is atomic with recent reauthentication. Platform operators are not implicit organisation members. All permissions are checked server-side for every route/action/download, not just in navigation.

## Authentication/session controls

Better Auth adapter/plugin schema from installed version; verified email, closed signup, secure recovery and invitation expiry. Require TOTP MFA for hosted privileged users, including sensitive operations during enrolment; no UI-only check. Configure session lifetime, idle expiry, invitation validity, rate limits and the recent-reauthentication window under deployment security policy; verify enforcement server-side rather than assuming library defaults. Sensitive actions require recent authentication and offboarding revokes sessions and memberships immediately. Use generic failure messages, test enumeration/brute-force resistance and use library-supported cryptography and cookie/session APIs. These security timeouts do not govern CRM record retention.

Production transactional mail must use verified TLS, either implicit TLS or a required STARTTLS upgrade. Do not permit an insecure fallback. Synthetic local mail capture may use plaintext within its private development network. Verification and recovery tokens must not enter application logs.

## Web/data controls

HTTPS secure HttpOnly SameSite cookies; supported CSRF/origin checks on mutations; restrictive CSP, nosniff and frame protection. Validate input with Zod, parameterised DB access, escaped plain text notes, pagination and size/rate bounds. No arbitrary HTML rendering. Optimistic concurrency and transactional audit preserve history. Errors/logs never expose secrets, request bodies, contact details or submitted documents. Environment/configuration is validated; placeholder secrets rejected in production.

Tenant boundaries cover DBs, storage, temporary artefacts, caches, jobs, search, logs and recovery. Test record-ID/path guessing and simultaneous requests. Runtime roles have no schema/provisioning privileges. Audit tables are insert-only for runtime; export/FX/roles/settings/archive/decision/grant-value/next-action events record actor, UTC time, target, reason and minimal diff. Operators cannot silently rewrite audit history through an app endpoint. Business audit is canonical CRM history, retained under organisation control with no age-based purge and support for at least a seven-year audit horizon; infrastructure log rotation is a separate policy.

Uploads use allowlist/signature/size/path validation, private staging and authorised attachment downloads; executable/public serving is prohibited. Production deployments document their upload-security control, including malware scanning where appropriate through a replaceable adapter or deployment-level mechanism. No scanner product or daemon is mandatory for every installation. If a scanner is configured, failed/unavailable inspection denies readiness for that upload. CSV import rejects invalid files atomically and CSV export prevents formula injection in text fields without corrupting machine-readable JSON/native decimal data. Temporary processing cleanup must never delete retained source records or attachments.

## Production host

The managed service uses dedicated production infrastructure. Self-hosted installations may use a VPS, on-premises server or other Docker-capable Linux host, provided the same application and data-access controls are met.

Production requires a default-deny firewall, private database access, key-based administration, disabled root SSH login and individually attributable privileged access. Keep the managed production host separate from development and unrelated workloads. Configure patching, credential rotation, bounded logs, health/disk/backup alerts and independent encrypted backups. Test restoration before real data and regularly under deployment policy; quarterly drills are an initial operational recommendation, not fixed product architecture. Retain a recovery point before upgrades. Automated development agents must not have unrestricted production-root access.

## Release gate

No real data until roles/MFA/isolation/deployment-appropriate upload controls pass, fresh-host deployment is proven, restores work, privacy/subprocessors/location/access procedures exist and critical/high applicable dependency issues are resolved or an explicit time-bound mitigation is recorded. Never copy real data into ordinary development/testing/staging. Source/dependency and image versions are documented; no paid security SaaS is required merely to satisfy this baseline.
