# Customer ownership, export and exit

Dependencies: data-model, tenancy, privacy and backups. Customer data belongs to the customer. Complete exit is a product requirement, not a premium service. One domain schema in hosted/self-hosted deployments.

## Export contract

Owner/Administrator can request a full tenant export; reauthenticate, audit and generate privately. Generated download packages follow configurable technical-artefact cleanup policy, never a product-wide fixed period. Expiring a package must not erase source records, retained documents or business audit, and an authorised user can generate another export. v0.01 must demonstrate structured export plus attachment manifest/download and a machine-readable reimport path; v0.05 validates complete hosted-to-self-hosted round-trip. A polished one-click archive is optional; a documented complete export command is mandatory.

Use versioned ZIP containing `manifest.json`, `data/*.json` and UTF-8 CSV views, `documents/*` and SHA-256 checksums. FormatVersion initially 1; identify app/schema versions, as-of UTC time, tenant ID, record counts and conversion metadata. JSON is the lossless import source; CSV is human/spreadsheet accessible. Stream safely/bound disk use; reject traversal during extraction. No public download path.

Include Funders, Contacts and affiliation history, Opportunities, Applications/decisions, Grants, Obligations, Tasks/next-action designations, Interactions/contact joins, all document links/bytes, archived records, actor display references, organisation interpretation settings, timezone/locale, FY boundaries, every budget-rate revision and appropriate tenant audit. Include a tenant-scoped member roster with display name, email, role, active state and actor reference, plus relevant tenant-scoped membership security events. Do not include another organisation's memberships or global authentication records. Financial exports include native decimal strings/ISO currency, planning year, target, applied rate/revision, unrounded conversion and displayed rounded conversion or explicit missing reason.

Exclude auth passwords, verification/session/MFA secrets, provisioner/runtime credentials, platform-wide logs, other tenants and internal support secrets. Exclusion of secrets must not remove material CRM interpretation/history. Include an actor-map manifest for historical authors; identities/memberships are recreated securely on import.

## Restore into self-hosting

Initial operator command contract: `pnpm tenant:restore -- --archive <private-archive> --slug <new-tenant>`. The operator container is the initial privileged execution mechanism, not an immutable product requirement. Validate format, schema compatibility, checksums and every relationship before mutation. Restore into a new tenant with routing disabled. Preserve the source organisation UUID and domain record IDs; a changed slug does not change those IDs. Reject an organisation-ID collision rather than merging with or replacing an existing tenant.

Restore historical actor references independently of login accounts. Create a fresh owner account/invitation and map it explicitly to the appropriate actor; retain the member roster for subsequent authorised invitations. Imported credentials and sessions must not remain usable. Move documents through the configured storage adapter and enable routing only after validation. Failed imports remain unavailable and report a safe retry or cleanup procedure.

Initial export command contract: `pnpm tenant:export -- --tenant <slug> --output <private-directory>`; authenticated UI delegates the same tenant-scoped service. A documented complete export route is required even if command mechanics change. Operator usage follows exceptional access controls; it must not become routine browsing. Normal customer administrators can export through their own UI without operator access.

## Proof

Round-trip the full synthetic primary tenant into a clean self-hosted instance. Compare counts/IDs/relationships, archived outcomes, native values, rate revisions, settings, historical audit attribution and every document checksum. Sign in as a newly bootstrapped owner and complete ordinary work. Managed-service endpoints blocked must not affect runtime. Confirm the secondary tenant is absent and export guessing is denied.

Include records and business audit older than seven years in retention/exit tests. Archived state and record age must not exclude them from lossless export or restoration. Internal FX history remains available in the export without becoming mandatory user-facing version management.

Closure offers export before deletion; refusing continued hosting never traps the data. Recovery backups supplement but do not replace an accessible customer export. No proprietary hosted-only field format or manual retyping is acceptable.
