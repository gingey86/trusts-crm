# ADR-001: Database per organisation

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

The initial hosted deployment serves a small number of organisations. Tenant isolation, independent restoration and portability are the primary database requirements.

## Decision

One PostgreSQL database per organisation, on a shared PostgreSQL server if appropriate. Each tenant has restricted runtime credentials. A control database stores tenant routing, authentication identity/membership and operational state only. No fundraising records or attachment metadata there. Self-hosting uses the same model with one tenant. v0.01 proves routing with a second synthetic isolation tenant.

Request context is resolved from a verified server session and active membership, then an allowlisted tenant registry entry. No client database URL, default tenant fallback or request-global mutable Prisma client. An unresolved/disabled tenant fails closed. Provisioning/migrations use separate operator credentials unavailable to the web process.

## Rationale

Database permissions reinforce application checks; backup, export, erasure and migration are independently manageable. Keeping authentication mapping centrally avoids trying every tenant database before login without centralising CRM content.

## Alternatives considered

Shared tables with tenant IDs and row-level security would make selective restoration and customer extraction more complex. A separate server for each organisation would add operational overhead beyond current requirements. Duplicated authentication databases would complicate login and identity management. Database-per-organisation provides the required isolation and recovery model on shared infrastructure.

## Consequences

Automated version tracking, provisioning, controlled connection pools and tenant-scoped tests are mandatory. Shared infrastructure still shares outage/operator risk; database isolation is not absolute isolation from host compromise. Cross-tenant CRM reporting is prohibited. See ../architecture/tenancy.md.
