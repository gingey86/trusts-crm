# System overview

Dependencies: technical-stack and ADRs. One repository, one codebase, one canonical /docs wiki. Development and ordinary testing use synthetic data only; real charity data requires an approved production environment.

## Components and boundaries

Browser → HTTPS reverse proxy → Next.js monolith. Better Auth validates identity using the control DB; request policy resolves active organisation membership and tenant registry; a tenant-specific Prisma client accesses only that organisation's PostgreSQL database. Services return permission-scoped UI data. Storage adapter reads private attachments after the same policy checks. SMTP sends verification, invitations and recovery, never bulk marketing.

Control records: identity/auth, memberships, tenant routing, schema versions, provisioning state and platform security events. Tenant records: all CRM, settings, rates, actor display references, document metadata and business audit. No funder/contact/search index/calendar/export contents in control DB. Platform logs use opaque tenant/request IDs; never CRM payloads.

Each self-hosted installation runs its own control database and Better Auth instance. It requires no account, registry, auth server, licence server or API belonging to the managed service, and no periodic internet access to remain operational. Offline deployment can use preloaded images; SMTP may be a local relay. There is no mandatory telemetry. Hosted and self-hosted use identical domain schemas and export formats.

Privileged setup provisions databases/credentials, migrates and bootstraps first owners through one supported user-facing command. The initial implementation uses a separate operator CLI/container internally; those mechanics may change while preserving privilege separation. The web app receives no provisioning or migration authority. App credentials can write necessary control auth records, but cannot CREATE DATABASE/roles. Tenant connections cannot read control/other tenant DBs. Platform operators have no implicit CRM UI membership.

Normal service support uses health, versions and redacted operational logs. No operator cross-tenant browsing screen. Exceptional backend access follows the recorded, individual, time-limited procedure in operations/support-and-production-access.md.

## Request discipline

Authenticate → active membership → validated routing → role permission → tenant-specific repository → transaction → audit → response. Revalidate on every operation, download, import, search, calendar and export. Client route/record IDs are selectors, never authority. Missing tenant or unknown credentials returns denial; no fallback. Include tenant ID in any cache key and avoid global mutable tenant clients. Background/operator work gets an explicit tenant context too.

Database transactions cover submission, decision/stage alignment, grant conversion, obligation completion and audit. Optimistic version fields prevent lost edits. Idempotency and unique constraints prevent duplicate Grants/Applications/import retries. Cross-DB changes use explicit pending/active/failed state, not pretend distributed transactions.

Tenant context also scopes storage keys, staging/export directories, cache keys, jobs, search, backup sets and restores. Technical artefacts follow configurable cleanup policy without removing source CRM records or retained attachments; identifier guessing never bypasses policy. Customer exit exports all material data, interpretation settings/rates, appropriate audit and attachments; a tested restore/import command migrates it to self-hosting without manual reconstruction.

## Persistence and recovery

Disposable application image/container; persistent PostgreSQL volume or external managed server; persistent private attachment volume; private configuration/secrets outside Git. Backup control DB, every tenant DB, files and recovery configuration independently off-host, encrypted. Tenant-aware restore must not overwrite other organisations. Infrastructure logs and backups follow documented operational rotation policies, separate from organisation-controlled CRM/business-audit retention. Canonical history supports at least a seven-year audit horizon and longer without automatic age-based deletion or archival. No code assumes existing local PostgreSQL, server mounts or cloud accounts.

## Delivery and documentation

Architecture/deployment.md defines Compose and configuration. Operations runbooks define install, upgrade, backup and restore. Development docs define scripts/tests. Keep live docs aligned in the same logical commits; new durable decisions supersede ADRs. Versioned images can replace source builds later without a new application fork.

The deployment uses PostgreSQL, application-managed authentication, database search and configurable private storage. Additional infrastructure requires a demonstrated operational need. Authorised administrators must be able to identify the application version, image digest and control/tenant migration versions; record these for every deployment.

## Stage boundaries

v0.01 proves complete synthetic workflow, two-DB isolation, auth/roles, CSV/export, private storage and a clean Docker-host portability exercise. v0.05 hardens provisioning, migration, authentication, monitoring and restore evidence before real data. v0.1 operates the controlled pilot on a dedicated secured VPS. Shared host compromise remains a pilot risk managed by access controls/backups, not by claiming database-per-organisation prevents every attack.
