# Trusts CRM

Trusts CRM is a purpose-built CRM for charities raising funds from trusts and foundations. It brings funder research, relationships, applications and grant obligations into one system, with the simplicity of a productivity tool.

The product is intended to replace the spreadsheets, Notion databases and shared documents that small fundraising teams use to manage this work. It is designed for free self-hosting, with an optional low-cost hosted service and no per-seat pricing.

## Development status

The project is at the specification stage. This repository contains the product and architecture documentation, acceptance criteria, synthetic fixtures and initial configuration files. The application, database migrations and tests have not yet been implemented.

The Docker and package files describe the intended build and deployment setup. They do not yet provide a runnable CRM. See [implementation status](docs/development/verification.md) for outstanding work.

## Product scope

The core workflow runs from a potential funder through an opportunity, application and decision to a grant and its reporting obligations. Funders retain their contacts, interactions, documents and previous applications so that the relationship remains understandable when staff change.

Pipeline and Calendar are the principal working views. The pipeline shows progress towards an application or award; the annual and monthly calendar shows deadlines, decisions and grant commitments drawn from the same records.

Multi-currency planning retains original amounts and uses each organisation's own annual budgeting exchange rates. Rates are managed through organisation settings; missing conversions are clearly identified.

The [scope document](docs/product/scope-and-exclusions.md) defines the release boundary. Individual giving, payment processing, accounting integrations, grant discovery and AI features are outside v0.1.

## Documentation

The [project wiki](docs/README.md) is maintained in this repository alongside the code. Useful starting points are:

- [Product specification](docs/product/product-spec.md)
- [Fundraising workflows](docs/product/workflows.md)
- [System architecture](docs/architecture/system-overview.md)
- [Deployment and configuration](docs/architecture/deployment.md)
- [Security baseline](docs/security/security-baseline.md)
- [v0.01 implementation roadmap](docs/roadmap/v0.01.md)
- [Acceptance criteria](docs/development/acceptance-tests.md)

Contributors should read [AGENTS.md](AGENTS.md) and the relevant specifications before changing behaviour or architecture. Documentation, migrations and tests must be updated with the implementation.

## Hosting and data ownership

Self-hosting is a core requirement. The supported deployment will use Docker Compose and PostgreSQL, with configurable private attachment storage. Hosted and self-hosted installations use the same codebase and data model; a self-hosted installation will not depend on the managed service.

The installation contract is configure an environment file, run one setup command, start Compose and complete the first-owner invitation. Setup handles database preparation internally while keeping privileged credentials out of the application. See [self-hosting](docs/operations/self-hosting.md); the setup tooling remains to be implemented.

Each organisation owns its data. Complete export and restoration must support migration to another installation without reconstructing records manually. Organisation boundaries apply to databases, attachments, temporary files, exports and recovery operations.

Fundraising records and business audit support at least a seven-year audit horizon and longer organisation-controlled retention. Record age never triggers automatic deletion or archival; temporary-file cleanup and backup/log rotation are separate operational policies.

Development and testing use synthetic data. Real charity data requires the secured production environment and the readiness checks defined for [v0.05](docs/roadmap/v0.05.md).

## Licensing

The project is intended to be open source. A software licence must be selected before the first public software release; this specification-stage repository does not yet contain a licence grant.
