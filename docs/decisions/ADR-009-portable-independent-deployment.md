# ADR-009: Portable independent deployment and customer exit

Status: Accepted. Date: 13 October 2026. Supersedes: none; supplements ADR-001/003/005/007. Superseded by: none.

## Context

Self-hosting, low cost, independence, reproducibility and customer ownership are foundational product constraints. Development and hosted infrastructure are deployment environments, never application dependencies.

## Decision

One codebase deploys through Docker Compose to clean Linux hosts, with bundled or configured external PostgreSQL, configurable persistent private storage and local control/auth registry. No mandatory managed-service account/auth/API/registry/licence check, telemetry, periodic internet validation, cloud provider or proxy. Source builds initially; versioned images/releases remain supported by the design. No source edits for installation.

Use conventional infrastructure with no mandatory commercial authentication, search or observability service. Customer exit exports all material records, settings, rates, history and documents in accessible versioned formats and supports tested migration to self-hosting. Tenant isolation covers files, temporary artefacts, caches, jobs, backups, restores and logs. Operating the service does not grant routine access to customer CRM contents.

## Rationale

Independent deployment and recoverable data ownership allow organisations to operate the system and move their data without depending on the managed service.

## Alternatives considered

Host-specific local services, separate hosted/self-hosted forks, managed control-plane dependency, paid per-seat auth/search and incomplete export: rejected. Mandatory vendor deployment tooling: unnecessary.

## Consequences

Documented configuration, migrations, first-owner bootstrap, persistent volumes, version identity, backup/restore and upgrade flow must be proven. Normal installation uses one setup command to orchestrate privileged preparation, followed by Compose startup and first-owner completion. Low-level operator commands remain available for advanced deployments without becoming prerequisites for ordinary users. Privileged credentials remain excluded from the application runtime. Clean-host portability is required before v0.01 structural completion and clean release install/upgrade/exit proof before v0.1. No undeclared development-host infrastructure is acceptable. Specific operator-container mechanics are an initial implementation choice; the security and portability boundaries are architectural constraints.
