# Data model

Dependencies: workflows and ADR-001/002/007/008. See ../../schema/conceptual-schema.md for relational constraints and fixtures for examples. UUID primary keys in implementation; fixture aliases are mapped deterministically. All ordinary records have createdAt, updatedAt (UTC), version, archivedAt/archivedBy and optional archive reason. No cascade hard deletion of historical links.

## Control database

Better Auth generated User/Account/Session/Verification/TwoFactor models; TenantRegistry(id, slug, connectionSecretRef, schemaVersion, provisioningState, enabled); Membership(userId, tenantId, role, active); Invitation through supported auth mechanisms; PlatformSecurityEvent(timestamp, actor, tenantId, action, redacted context). Unique membership pair and slug. Registry contains no CRM names/content beyond operational organisation identity. Secrets remain encrypted at rest or references to private operator-managed configuration.

## Tenant database

| Entity | Required facts and useful optional fields |
| --- | --- |
| Organisation | singleton ID matching registry; name, reporting currency, IANA timezone, locale, FY-start month/day; attention thresholds |
| ActorReference | stable tenant actor ID, historical display name and optional current control-user mapping; preserves attribution independently of login accounts |
| FinancialYear | ID, label, startDate, endExclusive; non-overlapping immutable boundaries |
| BudgetFxRateRevision | initial internal rate-history representation: year, source, target, revision, positive decimal rate, actor, reason, UTC createdAt; Settings exposes annual rates, not revision management |
| Funder | name, status, owner; website/type, theme/geography tags, typical min/max/currency, restrictions/application method, invitationOnly, reapplyAfter, notes, reference/address/contact details |
| Contact | name, status, job title, email/phone, notes/preferences; dated ContactFunder affiliations with one current funder |
| Opportunity | funder, title, owner, stage, planning year; purpose, estimate/currency, probability, priority, restricted/unrestricted/unknown, deadline, planned submission, pre-submission expected decision, funding dates, notes |
| Application | Opportunity FK; version label, submittedDate, requested amount/currency/year, expected decision, decision status/date, feedback, awarded amount/currency/year on success |
| Grant | unique Application FK; funder/title/owner/purpose, awarded amount/currency/year, start/end, status, restriction classification, notes |
| Obligation | Grant FK, title, type, dueDate, responsible actor, status; submission/completion dates/actor, optional payment amount/currency/year, notes/reason |
| Task | title, owner, status, priority, dueDate, notes; typed optional related FK; completed date/actor |
| NextAction | current Task designation per Funder or Opportunity; task must be linked/open; one designation per Task; significant designation changes retained in business audit |
| Interaction | funder, occurredDate, type, summary, recording actor; details, optional Opportunity/Grant, contact joins and affiliation snapshot |
| Document | name, MIME, bytes count, checksum, opaque key, backend, upload timestamp/actor, state/description; typed parent links |
| AuditEvent | append-only timestamp, actor, action, type/ID, correlation ID, minimal structured diff/reason |
| ImportBatch | type, content hash, idempotency key, status/counts, actor/time; transient uploaded CSV follows configurable technical cleanup, retained source documents do not |
| ExportManifest | format/app/schema versions, timestamp, actor, checksums, conversion basis; generated package follows configurable cleanup, relevant export business audit remains canonical |

Use explicit contact joins on Opportunity/Grant and explicit DocumentLink FKs so integrity is enforceable. Shared documents may link to Application and Grant without copying bytes. No CustomObject, CalendarEvent, generic arbitrary relation schema or project-management entity.

## Derived fields and invariants

Last interaction comes from non-archived Interactions. Next action comes from designated Task. Weighted/conversion values are projections using decimals and ADR-002 basis, not editable stored amounts. Overdue and attention flags derive from dates/status/local today. Application controls submission/decision after submission; Opportunity reads them rather than duplicating writable dates. Grant value and Application award must reconcile through an audited correction transaction.

Every FK stays inside a tenant DB; validate funder consistency for contact/interactions/grants. One live pending Application per Opportunity and one Grant per successful Application. Foreign keys restrict deletion. Terminal workflow transitions, role checks and optimistic concurrency are service invariants supplemented by DB checks/indexes. No arbitrary IDs or client-provided actor/tenant fields are trusted.

Canonical domain records, attachments, settings, financial years, FX history, archive metadata and business AuditEvent history have no age-based expiry or automatic archival. Support at least a seven-year audit horizon and longer organisation-controlled retention. Deliberate erasure follows the authorised privacy procedure; clearing current next-action state or cleaning technical artefacts must not erase its significant history. Infrastructure/security telemetry rotation is distinct from retained business audit.

Funder/Contact/Opportunity may retain optional unique externalKey per entity for CSV parent resolution; imported keys are scoped to the tenant and never authentication authority. An ImportBatch maps explicitly confirmed source keys, rejects ambiguous/invalid references and prevents duplicate confirmation. Do not infer historical Applications from imported Opportunity stage alone; lossless historical transfer uses organisation restore.

## Reporting and export

All domain tables, links, historical affiliations, settings, FY boundaries, rate revisions, native values, archived metadata and appropriate tenant audit belong in portable export. Export the selected organisation's member roster and relevant membership security events from the control database through an authorised tenant-scoped service; never export the full control database.

Actor references have stable IDs distinct from authentication user IDs. Preserve them and their historical display information during restore, then map new login accounts explicitly. Passwords, sessions and MFA secrets are excluded. Restore preserves the organisation UUID and record IDs, rejecting identity collisions with existing tenants. Document bytes and checksums accompany metadata. Hosted and self-hosted installations use the same schema and export format.
