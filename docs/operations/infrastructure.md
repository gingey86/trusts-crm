# Infrastructure requirements

The standard installation runs the application, PostgreSQL and private attachment storage on one Linux server. Independent backup storage and transactional email are required for production. No commercial database, authentication, search or monitoring service is mandatory.

| Component | Purpose | Requirement |
| --- | --- | --- |
| Linux server | Application, control and tenant databases, private files | Docker/Compose, persistent storage and sufficient measured capacity |
| Backup destination | Independent recovery | Encrypted storage outside the primary host; documented retention and restoration tests |
| SMTP relay | Verification, invitations and recovery | Configurable transactional SMTP; a local relay is supported |
| DNS and reverse proxy | Public application origin | Configurable HTTPS origin; no required provider |
| Monitoring and logs | Health, disk, backup and security alerts | Bounded logs and alerts; local or open-source tooling is sufficient |
| TLS certificates | Encrypted browser access | Valid certificates and a documented renewal process |
| Optional malware inspection | Deployment-appropriate upload control | Replaceable scanner or deployment-level mechanism where selected; maintain it and fail closed for uploads requiring inspection; no mandatory product/provider |

PostgreSQL may run in the Compose stack or on an externally managed server. Better Auth runs within the installation. Search uses the tenant database, and attachment storage uses the configured adapter. New infrastructure dependencies require an explicit purpose and a review of their security, portability and maintenance implications.

## Capacity and operation

Measure memory, disk use, database connections and response times against expected record volumes and concurrent users. Include uploads, exports, backups and any configured scanning in capacity tests. Bound connection pools, temporary artefacts and log growth, and alert before persistent storage is exhausted. Pool/cache sizes and selected infrastructure tools are measured implementation/deployment choices, not fixed product architecture. Document operational log and backup policies separately from organisation-controlled CRM/business-audit retention.

Record operational providers, data locations, subprocessors and access arrangements in the appropriate restricted service inventory. Keep deployment and privacy documentation aligned when infrastructure changes. Security controls and recovery requirements remain mandatory for every installation.
