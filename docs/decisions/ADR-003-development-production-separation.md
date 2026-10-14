# ADR-003: Development and production separation

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Non-production development environments are not approved infrastructure for charity data. Authentication, authorisation and tenant-routing foundations must be demonstrated during prototype development before production hardening.

## Decision

v0.01 development and ordinary testing use fictional synthetic data exclusively. No real imports, copies, exports, attachments, backups or production credentials belong in those environments. Before real records are accepted, complete the v0.05 gate and deploy to an approved production environment. Managed hosting uses a dedicated production VPS; a single secured pilot VPS is acceptable. Self-hosting uses the same security gate on the organisation's chosen infrastructure. Routine coding agents have no autonomous production-root access.

Development and production use separate secrets, storage, databases, mail transport and backups. Synthetic seeding refuses production mode and requires explicit environment acknowledgement. UI labels development as synthetic-only; a banner does not itself enforce data provenance. Operators must not paste real data into local forms.

## Rationale

Prevent privacy exposure before production controls are proven. Early security tests reduce later architectural rewrites.

## Alternatives considered

Real-data testing in ordinary development: prohibited. Production experimentation: prohibited. Postponing role/routing checks until deployment: rejected because isolation and authorisation shape the domain-service architecture.

## Consequences

v0.01 demonstrates boundaries; v0.05 validates production operations. Dedicated infrastructure, off-site encrypted restore-tested backups and deliberate deployments precede v0.1. Fixtures contain fictional organisations and records only.
