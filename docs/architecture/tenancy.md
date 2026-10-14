# Tenancy and end-to-end isolation

Dependencies: ADR-001/006, system-overview, data-model. One DB per organisation in every deployment mode. A self-hosted installation owns its local control/auth registry and runs independently of the managed service.

## Resolution

Verify Better Auth session; lookup active Membership and enabled TenantRegistry; build immutable request TenantContext(userId, tenantId, role, validated connection reference). An optional organisation selector may choose only memberships already authorised server-side. Unknown/disabled tenants deny access. Never fall back to a default database. Tenant names/slugs/IDs from a URL cannot select arbitrary connections. Credential URLs stay server-side.

Use separate Prisma clients keyed by allowlisted tenant ID, with bounded connection pools and client-cache resources. Exact pool counts and cache algorithm are measured initial implementation choices, configurable for the deployment with operator headroom. Dispose evicted clients. No shared mutable currentTenant variable. Repository constructors require context; tests reject unscoped use.

## PostgreSQL permissions

Tenant runtime role has CONNECT only to its database, USAGE on its schema, required CRUD on CRM tables and INSERT/SELECT only on audit tables. Revoke PUBLIC CONNECT on tenant/control DBs, schema CREATE and role inheritance. Use distinct migration owner and provisioner; runtime cannot CREATE DATABASE/ROLE, change schemas or access other tenants. Integration tests try direct cross-database connections as well as web attacks. Restrict network access and require TLS for remote DBs.

## Provisioning and migration

`tenant:create` validates the identifier, creates a pending registry entry, provisions restricted roles and a tenant database, applies migrations and creates the organisation settings. A successful database/schema health check moves the tenant to a ready state, with routing still disabled. `owner:bootstrap` creates the first-owner membership and invitation, then enables routing after the required checks. Owner verification and MFA must complete before privileged CRM access is permitted.

Failed provisioning leaves the tenant unavailable and records the failed step. Retry only resources belonging to the same provisioning attempt; an existing customer database must not be deleted or recreated automatically.

Web UI cannot invoke database creation with privileged credentials. Normal self-host installation uses the supported setup command to orchestrate the above internal operations for one tenant; users do not run each role/migration/provisioning command manually. v0.01 also tests two fictional tenants through that mechanism. Versioned control/tenant migrations track per-tenant version/status and failures, with migration concurrency protection; advisory locks are the initial implementation choice. A tenant with incompatible schema is not routed to a newer app until migrated; one failure must not silently declare fleet success.

Membership and role changes are recorded with their security event in a control-database transaction. CRM mutations and their business audit events use a tenant-database transaction. Organisation audit views may include relevant control security events only after tenant authorisation and explicit tenant filtering. Operations spanning both databases use documented pending/failed states; they are not treated as a single PostgreSQL transaction.

## Boundaries beyond DBs

| Surface | Required boundary |
| --- | --- |
| Attachments | tenant/opaque-key storage prefixes; authorised parent lookup; no static public mount |
| Uploads/exports | private tenant-scoped staging, opaque ID, ownership check, configurable technical-artefact cleanup; retained sources untouched |
| Caches | tenant ID and relevant permissions in keys; no shared CRM response cache |
| Jobs | explicit immutable tenant context, narrow credentials and artefact prefix |
| Search/calendar | query only resolved tenant; no central content index |
| Backups/restores | per-tenant named encrypted sets, checksum manifests, isolated destination checks |
| Logs | no CRM bodies; restricted tenant-specific audit access; operators see redacted health |
| Migration/temp data | tenant-specific private work directory; configurable temporary-artefact cleanup; no mixed exports or canonical-history expiry |

No organisation administrator can browse other organisations or their generated artefacts. Same record IDs in two DBs must still be isolated. Include concurrent mixed-tenant requests, cache warming, guessing paths and failed resolution in acceptance tests.

## Operator boundary and customer exit

Operators have no generic CRM superuser UI. Normal tasks use health/provisioning/version metadata only. Exceptional data access follows the support runbook. Complete tenant export carries domain/settings/rates/history/files and checksums; authenticated operator restore into a fresh self-hosted tenant preserves record IDs and actor history, recreates memberships and invalidates imported credentials. See operations/data-portability.md.
