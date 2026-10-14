# Self-hosting

Dependencies: architecture/deployment.md, security-baseline and backups-and-restore.md. The application and operator commands below remain to be implemented. This installation sequence must pass on a clean Docker-capable host before v0.01 acceptance.

## Prerequisites

Clean Linux host with Docker Engine/Compose v2 and Git. A starting sizing example is 2 vCPU, 4 GB RAM and adequate persistent disk; measure for the actual workload and any optional inspection service before production. Docker command access is privileged. Use a private environment file with mode 0600 and a supported HTTPS reverse proxy before real data. Setup must require no host Node.js or separately installed PostgreSQL. For offline use preload versioned images/dependencies and use internal SMTP; no managed Trusts CRM account or internet validation is required to keep running.

## Fresh installation sequence

1. Clone the chosen release repository into any administrator-owned directory. No remote provider is assumed. Record release/commit.
2. Copy `.env.example` to `.env`; configure public APP_URL/BETTER_AUTH_URL, DATABASE_MODE, SMTP and first-organisation/owner details. Configure ports, storage, mode and timezone where needed. For external PostgreSQL, supply the authorised operator connection and any administrator-provided restricted connections. Ordinary bundled installations need not understand or create individual database roles.
3. Run `./scripts/setup.sh`. This supported wrapper prepares private secrets/configuration, starts the selected bundled database and synthetic mail service where appropriate, builds or obtains matching images, creates restricted database roles, runs migrations, provisions the first organisation and sends its first-owner invitation. Missing organisation/name/email values may be collected interactively. It reports failures clearly and supports safe retries without replacing existing secrets, accounts or customer databases.
4. Start `docker compose up -d app`, configure the HTTPS proxy for production and verify health. Database and attachment storage remain persistent independently of the application container.
5. Open the owner invitation after the application is reachable; complete email verification, password setup and applicable privileged MFA. The invitation is one-use with validity governed by security policy.
6. Configure reporting currency, financial years and annual budget rates through Settings, then begin using the CRM.

The wrapper and application commands are implementation contracts, not working features in the current repository. One supported setup command is required; its initial name is `scripts/setup.sh`. Preserve privilege separation, one-use owner bootstrap and safe retries if implementation mechanics change, and update these instructions with the tooling.

## Internal preparation and advanced deployments

The wrapper invokes an internal `pnpm setup` orchestrator using operator-only authority. It coordinates `setup:database`, `db:migrate`, `tenant:create` and `owner:bootstrap`; those low-level commands remain available for troubleshooting, existing tenants and externally managed database arrangements. They are not separate steps in ordinary installation. Control runtime credentials, migration credentials and provisioning privileges remain distinct, and the web application never receives the latter two. Tenant credential files require private ownership compatible with the non-root application. Review the deployment/tenancy contracts before manual operator work.

## Synthetic development variant

Use APP_ENV=development, the synthetic-data acknowledgement, `.invalid` identity addresses and the local mail-capture relay. Setup starts synthetic mail capture when selected; the separate seed command creates fictional records only. Keep `.env` private and exclude real charity imports from this environment. Production requires its own approved configuration and real transactional mail.

## Administration

Organisation Owner/Administrator invites users via Settings, configures annual rates and exports data. Service operations use the operator container with explicit credentials and tenant selectors. No hidden runtime dependency on the original developer, host, project service or Cloudflare. Health reports redact DB URLs and expose only minimal public liveness; authenticated version diagnostics show app/schema versions.

Do not use `docker compose down -v` on an installation with data: it removes persistent volumes. App recreation/upgrades preserve DB, attachment and tenant-credential volumes. Back up independently off-host; server snapshots alone are insufficient. Follow upgrades.md and data-portability.md.

## Portability proof

Run the normal installation sequence on a clean host using only the repository/template, including a different configurable port/path and external PostgreSQL variant. No manual internal role/provisioning sequence may be needed to rescue an ordinary bundled installation. Verify sign-in, lifecycle, file persistence after app recreation, backup/restore and independence when managed-service internet endpoints are blocked. Record version, exact commands, deviations and result in docs/development/verification.md during implementation. No undeclared development-host prerequisite is acceptable.
