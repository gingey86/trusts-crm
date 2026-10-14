# ADR-010: Public repository and documentation

Status: Accepted. Date: 13 October 2026. Supersedes: none; clarifies ADR-005. Superseded by: none.

## Context

An open-source project needs accessible specifications and a shared development history. Maintaining documentation separately from the code increases the risk of inconsistent requirements and outdated installation instructions.

## Decision

Maintain the source, migrations, synthetic fixtures and Markdown documentation in the public [gingey86/trusts-crm](https://github.com/gingey86/trusts-crm) repository. The `/docs` directory is the project wiki and is reviewed and versioned alongside implementation changes.

Private customer data, credentials, operational incident records, attachments and database volumes must not enter the repository. Public documentation must describe the product, architectural rationale, development procedures and implementation status without personal or conversational narrative.

## Rationale

A single repository makes specifications available to contributors and allows documentation changes to be reviewed with the code they describe. Git history records how requirements and implementation evolve.

## Alternatives considered

A separate documentation service would introduce another source of truth and synchronisation work. Local-only documentation would prevent public contribution and independent review. Neither is required for the project's current scale.

## Consequences

Contributors must update relevant documentation with code changes and check proposed commits for private data. GitHub is the current repository host, but it is not an application runtime dependency. Repository visibility does not grant an open-source licence; a software licence must be selected before the first public software release.
