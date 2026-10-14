# Implementation and verification status

Status: specification stage. Application version: `0.0.1-prebuild`.

The repository contains specifications, acceptance criteria, synthetic fixtures and deployment configuration. The application source, Prisma schemas and migrations, operational commands and automated test suites remain to be implemented.

## Completed checks

| Check | Result |
| --- | --- |
| Required documentation and configuration files | Present |
| Relative Markdown links | Valid |
| ADR structure | Required fields present |
| Package manifest and synthetic fixtures | Valid JSON |
| Compose configuration | Valid YAML; environment references covered by `.env.example` |
| Credential separation in Compose | Provisioning and migration credentials excluded from the application environment |
| Persistence configuration | Database, attachment and tenant-credential volumes declared; PostgreSQL has no exposed host port |
| Repository exclusions | Credential files, private data, dependencies and generated state excluded; legitimate source paths under storage/export modules remain trackable |
| Synthetic fixtures | 24 funders, 24 opportunities, 10 applications, two grants and 12 obligations; references, monetary/date formats, historical interaction dates and submission chronology checked |
| Currency test example | GBP 17,700 converted subtotal and GBP 8,850 weighted subtotal; EUR records remain unconverted |
| High-value arithmetic example | Exact decimal multiplication and final half-up rounding independently checked; application implementation remains pending |

These checks validate repository files. They do not establish that the application, deployment or security controls work.

## Outstanding implementation and validation

| Area | Required work |
| --- | --- |
| Dependencies | Complete normal installation, generate the lockfile and verify package compatibility and security |
| Licence | Select and include an open-source licence before the first public software release; no licence is selected by this specification |
| Application | Implement the domain services, primary views and complete fundraising lifecycle |
| Database | Implement control and tenant schemas, restricted roles, provisioning and versioned migrations |
| Authentication | Integrate Better Auth and verify sessions, recovery, MFA and role enforcement |
| Storage and portability | Implement secure private uploads, deployment-dependent optional inspection, CSV import, complete export and restoration |
| Historical integrity | Prove organisation-controlled CRM/business-audit retention beyond seven years and source-safe technical cleanup; no age-based deletion/archival |
| Automated tests | Implement and pass the unit, PostgreSQL integration and browser acceptance suites |
| Deployment | Implement the single-command setup wrapper/orchestrator and prove normal clean-host installation, safe retries, local/external PostgreSQL and privileged/runtime credential separation |
| Recovery | Demonstrate upgrades, migration retries and coordinated backup/restore |
| Production readiness | Verify HTTPS, deployment-appropriate upload controls and configured inspection where applicable, privacy procedures, access controls and providers; establish operational timeout/log/backup policies separately from CRM retention |

`pnpm-lock.yaml` is not yet present. The Dockerfile and package scripts depend on application files that do not yet exist. Their inclusion describes the intended deployment contract, not a successful build.

## Milestone evidence

[v0.01 acceptance](acceptance-tests.md) requires A01–A16 using synthetic data. The [v0.05 gate](../roadmap/v0.05.md) requires production security and operational evidence before real charity data is accepted. [v0.1](../roadmap/v0.1.md) requires release installation, upgrade and customer-exit tests, followed by controlled pilot use.

For each completed check, record the application commit/version, test environment, command or procedure, result and any unresolved limitation. Customer data, credentials and private incident evidence must remain outside this repository.
