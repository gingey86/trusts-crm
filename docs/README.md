# Trusts CRM documentation

The `/docs` directory contains the authoritative project documentation, version-controlled alongside code. Start with the [product specification](product/product-spec.md), then the relevant workflow, architecture, security and acceptance documents.

Product requirements describe observable behaviour; architectural constraints define durable boundaries. Initial implementation choices, configurable operational defaults and example configuration describe the starting engineering approach, not additional product requirements. Resolve tested dependency versions and deployment settings during implementation and keep the relevant documents aligned. A licence remains an outstanding decision before the first public software release.

## Structure and reading order

| Directory | Purpose | Key documents |
| --- | --- | --- |
| product | What the product does and excludes | [Specification](product/product-spec.md), [scope](product/scope-and-exclusions.md), [workflows](product/workflows.md), [UI](product/ui-spec.md) |
| architecture | System/domain/deployment contracts | [Stack](architecture/technical-stack.md), [overview](architecture/system-overview.md), [model](architecture/data-model.md), [tenancy](architecture/tenancy.md), [storage](architecture/file-storage.md), [deployment/config](architecture/deployment.md) |
| security | Required controls and privacy handling | [Baseline](security/security-baseline.md), [threat model](security/threat-model-v0.01.md), [privacy](security/privacy-and-data-handling.md) |
| development | Build procedures and acceptance criteria | [Environment](development/environment.md), [testing](development/testing.md), [acceptance](development/acceptance-tests.md), [verification status](development/verification.md) |
| operations | Installation, maintenance, recovery and data exit | [Self-hosting](operations/self-hosting.md), [upgrades](operations/upgrades.md), [backups/restore](operations/backups-and-restore.md), [data portability](operations/data-portability.md), [support access](operations/support-and-production-access.md), [incidents](operations/incidents.md), [infrastructure](operations/infrastructure.md) |
| roadmap | Milestone scope and gates | [v0.01](roadmap/v0.01.md), [v0.05](roadmap/v0.05.md), [v0.1](roadmap/v0.1.md) |
| decisions | Durable accepted decisions and history | [ADR directory](decisions/) and records below |

## Architecture Decision Records

- [ADR-001 Database per organisation](decisions/ADR-001-database-per-organisation.md)
- [ADR-002 Annual budget exchange rates](decisions/ADR-002-budget-exchange-rates.md)
- [ADR-003 Development/production separation](decisions/ADR-003-development-production-separation.md)
- [ADR-004 Core annual/monthly calendar](decisions/ADR-004-calendar-as-core-view.md)
- [ADR-005 Scope and canonical wiki](decisions/ADR-005-product-scope-boundary.md)
- [ADR-006 Authentication](decisions/ADR-006-authentication-approach.md)
- [ADR-007 Attachment abstraction](decisions/ADR-007-attachment-storage-abstraction.md)
- [ADR-008 Money/date representation](decisions/ADR-008-money-and-date-representation.md)
- [ADR-009 Independent portable deployment/exit](decisions/ADR-009-portable-independent-deployment.md)
- [ADR-010 Public repository/wiki](decisions/ADR-010-public-repository.md)

## Supporting repository artefacts

[AGENTS](../AGENTS.md), [root README](../README.md), [configuration template](../.env.example), [Compose](../docker-compose.yml), [Dockerfile](../Dockerfile), [package manifest](../package.json), [conceptual schema](../schema/conceptual-schema.md), [synthetic specification](../fixtures/synthetic-data-spec.md) and [seed data](../fixtures/seed-data.json). These are versioned supporting artefacts; important explanatory decisions remain in the wiki.

## Maintenance contract

| Change | Update together |
| --- | --- |
| Behaviour/scope or workflow | product specification/workflows/UI, acceptance and relevant roadmap; ADR for durable changed scope |
| Entity/constraint/money/date | data-model, conceptual schema, ADR as needed, migration, fixtures and integrity tests |
| Auth/roles/tenant/storage | architecture, security/threat model, relevant ADR, tests and operational handling |
| Installation/env/scripts/images | deployment, self-hosting/upgrades, .env.example/Compose/package/Dockerfile and portability evidence |
| Backup/deletion/support/infrastructure | operations/privacy docs, measured evidence and any architectural ADR |
| Milestone status | roadmap and verification, actual test results and known blockers |

Use logical Git commits grouping code, tests and relevant wiki. Never allow silent divergence. When implementation makes an assumption concrete, update the live document. Changed architectural decisions get a new numbered ADR; mark/link the prior ADR as superseded while retaining historical reasoning. No disconnected external wiki is required. Private customer/incident/secret records stay in restricted operational storage, never public Git; this wiki defines their procedures.

## Current state

The project is at the specification stage. Application source, schemas, migrations, operational commands and tests remain to be implemented. The [implementation status](development/verification.md) distinguishes completed repository checks from outstanding application and deployment validation.

Repository: [gingey86/trusts-crm](https://github.com/gingey86/trusts-crm), branch `main`. The project wiki is maintained in `/docs`; the separate GitHub Wiki feature is not used. See [verification status](development/verification.md) for implementation readiness and outstanding checks.
