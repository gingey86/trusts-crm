# Portable deployment and configuration contract

Dependencies: system-overview, tenancy, technical-stack and file-storage. Standard target: Docker Compose v2 on a clean Docker-capable Linux host. Same codebase and schema for managed/self-hosted operation; each installation runs its own control/auth DB. No mandatory external project service, periodic licence check, telemetry, DNS provider or reverse proxy.

## Implementation status

The application and operational commands remain unimplemented. The current files define the intended deployment contract. Application images require source, schemas, migrations and a generated dependency lockfile before they can build. v0.01 acceptance requires the documented installation sequence to work on a clean host; v0.1 repeats that test using release artefacts in a clean environment.

## Stack

The normal installation route is configure `.env`, run `./scripts/setup.sh`, start `docker compose up -d app`, then complete the first-owner invitation. The setup wrapper remains to be implemented: it handles secure generated configuration, selected database startup, image preparation, restricted-role creation, migrations, first organisation and owner bootstrap without requiring users to run each internal command. It requires Docker/Compose rather than a host Node.js or PostgreSQL installation. Advanced operator commands remain available for troubleshooting.

The initial Compose design uses profiles for bundled PostgreSQL (`local-db`) and synthetic mail capture (`dev-mail`), selected by setup as appropriate. App and operator images share source/dependencies but operator receives elevated DB credentials only when explicitly invoked. App binds a configurable loopback host port by default; PostgreSQL exposes no host port. Persistent named volumes store DB, private attachments and operator-created tenant credential files. App reads generated tenant credentials read-only; no tenant routing secrets are browser-visible. Control runtime role differs from PostgreSQL bootstrap/migration role. Container targets, profile names and credential-file mechanics are initial choices; the privilege/persistence boundaries are constraints.

Source builds use the Dockerfile and a generated pnpm lockfile. Published application and operator images can be selected independently with APP_IMAGE and OPERATOR_IMAGE, including immutable digest references. Record both image identities for each release. Keep the Compose project name and persistent volumes consistent during upgrades.

For external PostgreSQL, select DATABASE_MODE=external and configure the operator connection. Setup omits the local-db profile and creates or validates restricted connections. The selected server must permit database/role provisioning through the operator account or provide an equivalent documented advanced provisioning mechanism. Runtime credentials retain the same tenant isolation requirements.

## Environment contract

All server variables validated at startup. Fail on missing secrets/invalid modes; never default to a different tenant. `.env.example` holds placeholders, no operational credentials.

Ordinary installers configure deployment origin, database mode, mail and first-organisation details. Setup generates missing bootstrap/auth secrets and restricted internal-role credentials into private configuration before Compose validation/startup; it never replaces existing credentials on a retry. Existing or externally managed credentials are validated rather than silently changed. The low-level connection variables below remain documented for advanced use, not separate manual installation tasks.

| Variable | Purpose / validation |
| --- | --- |
| APP_ENV | development, test or production; synthetic seed denied in production |
| DEPLOYMENT_MODE | self-hosted or managed; same application, no remote control-plane URL |
| DATABASE_MODE | setup choice local or external; local starts bundled PostgreSQL, external uses configured server |
| SETUP_ORGANISATION_NAME / SETUP_ORGANISATION_SLUG / SETUP_OWNER_EMAIL | first-run setup inputs; prompt for missing values; no production/customer defaults |
| APP_URL / BETTER_AUTH_URL | identical public absolute origin; HTTPS in production |
| APP_BIND / APP_PORT / INTERNAL_PORT | host bind/port and container listener; configurable |
| APP_IMAGE / OPERATOR_IMAGE / APP_VERSION | independent application/operator image references and application release identity |
| NEXT_TELEMETRY_DISABLED | set to 1 for framework builds and runtime; no mandatory telemetry |
| CONTROL_DATABASE_URL | restricted control runtime DB connection; secret |
| CONTROL_MIGRATION_DATABASE_URL | control schema-owner connection; operator only |
| PROVISION_DATABASE_URL | database/role provisioning connection; operator only |
| POSTGRES_DB / USER / PASSWORD | local stack bootstrap DB/role credentials; secret password |
| TENANT_CREDENTIALS_DIR | private mounted connection-file directory, app read-only |
| BETTER_AUTH_SECRET | cryptographically random >=32 bytes, private and rotatable |
| SMTP_HOST / PORT / USER / PASSWORD / SECURE / FROM | transactional SMTP; SECURE selects implicit TLS; production with SECURE=false must require STARTTLS and certificate verification; local capture is synthetic-only |
| STORAGE_BACKEND / STORAGE_ROOT | local implemented initially; root within mounted persistent storage |
| MAX_UPLOAD_BYTES / MAX_IMPORT_BYTES | positive configurable size bounds; initial defaults 20971520 / 5242880 |
| DEFAULT_TIMEZONE / DEFAULT_LOCALE | new-organisation defaults; IANA timezone and en-GB |
| LOG_LEVEL | debug/info/warn/error; production defaults info, redaction mandatory |
| TRUSTED_PROXY_CIDRS | empty means trust no forwarded client-IP headers; exact proxy networks only |
| SYNTHETIC_DATA_ACK | explicit local seed acknowledgement, never permission for real data |

Tenant runtime URLs are generated by the operator and held in private per-tenant credential files referenced by registry IDs, not in an ever-growing `.env` list. The app-mounted directory contains runtime credentials only; no provisioning or schema-owner credentials. Operators perform migrations with their separately supplied provisioning/migration authority. Runtime cannot enumerate credentials via an HTTP route. Files require private permissions; backup separately. Secrets may later use equivalent Docker secret/file providers; document actual support rather than assuming every env has a `_FILE` option.

## HTTPS and operations

Place a conventional reverse proxy (Caddy/nginx/Traefik or equivalent) in front of the loopback listener. Proxy forwards public Host/proto correctly; application trusts only configured proxy sources. If proxy is a container, choose a deliberate shared network/configurable bind and restrict firewall access. No required Cloudflare behaviours. Production exposes HTTPS only, redirects HTTP, uses secure cookies and security headers. Configure database TLS for remote managed PostgreSQL.

Migrations are explicit operator jobs, not arbitrary web-start side effects. Bootstrap and upgrade commands are specified in operations/self-hosting.md and upgrades.md. Secrets/configuration, databases, attachments and tenant credentials are independent persistent recovery components. Image/container replacement must preserve them.

The pre-build Compose template provides synthetic development mail and database services. Before production, document and test deployment-appropriate upload controls. Scanning may use a replaceable adapter or deployment-level mechanism, with optional provider-specific configuration documented when implemented. No scanner daemon or scanner-specific variables are part of the mandatory generic environment contract. A configured scanner must fail closed for uploads requiring its inspection. Healthcheck timings and log-rotation sizes in Compose are adjustable initial operational defaults, not fixed product architecture. No application runtime depends on the managed Trusts CRM service; ordinary security maintenance/update delivery may use the administrator's own infrastructure.
