# Instructions for coding agents

## Authoritative memory

The `/docs` wiki is authoritative. Read [docs/README.md](docs/README.md), the [product specification](docs/product/product-spec.md), [scope](docs/product/scope-and-exclusions.md), relevant workflows/UI/architecture/security documents, [ADRs](docs/decisions/) and acceptance criteria before changing product behaviour or architecture. Implementation must conform to the version-controlled specifications.

Update documentation whenever implementation makes a document inaccurate or a technical assumption concrete. Code, relevant tests and wiki must change together where appropriate. Avoid undocumented architectural changes. Durable changed decisions require a new ADR and supersession links; mark historical ADRs superseded without rewriting their reasoning. Keep docs/index links current. Surface only genuine contradictions/material product decisions, not routine engineering choices.

## Fixed constraints

- Trusts/foundations fundraising only. No standard-CRM scope additions, excluded integrations, AI, live FX or custom workflow/object engine.
- Development and hosted infrastructure are deployment environments, not application dependencies. All implementation must remain portable to a clean Docker-capable Linux host; local convenience must not compromise deployability.
- Development and ordinary testing use synthetic data only. Real charity records, imports, files, exports, backups and production credentials are prohibited there. The production readiness gate must pass before real data is accepted in an approved production environment.
- One PostgreSQL database per organisation. Central/local control DB contains auth/routing/operational metadata only; never fundraising data or a shadow CRM.
- Tenant isolation includes databases, files, backups and temporary artefacts, plus caches, jobs, restores, logs and search. Fail closed; no default-tenant fallback, client-selected DB URL or shared mutable tenant context.
- Mature authentication (Better Auth), server roles, private attachments outside rows through a Storage abstraction. No hand-rolled auth. Hosted privileged users require MFA.
- Annual/monthly Calendar and Pipeline are primary views. Events derive from records; no independently maintained dates or daily/weekly-agenda-centred design.
- Native decimal amount plus ISO currency always retained; no binary floating-point money. Organisation administrators configure annual budget FX in Settings. Missing rates allow native save, visibly incomplete conversion and honest totals.
- Customer data belongs to the customer and must remain portable. Full exit includes all material records/settings/rates/history/appropriate audit and documents, with compatible hosted/self-hosted models and tested restoration.
- Support at least a seven-year audit horizon and longer organisation-controlled CRM retention. Never delete, expire or archive canonical records, attachments or business audit because of age. Temporary artefact cleanup, infrastructure logs and backup rotation are separate operational policies.
- Hosted-service administration does not imply unrestricted routine access to customer CRM data. No generic platform CRM superuser UI. Exceptional access is deliberate, individual, constrained, reasoned and logged.
- Keep infrastructure requirements proportionate to the workload. Avoid unnecessary external services and preserve independent self-hosting. Security and recovery controls remain mandatory.
- Self-hosted installations remain fully independent of managed hosting. Local auth/control, no managed-service account/API/registry/licence validation, mandatory telemetry or periodic internet check. Cloudflare/proxy/provider optional.

## Delivery discipline

Use the conventional stack and implementation order in environment.md/v0.01.md. This baseline is a pre-build pack: scripts/schemas/routes/test configs still need implementation; do not describe them as existing. Generate pnpm-lock.yaml only through normal successful installation. Commit safe source, migrations, Markdown, synthetic fixtures and .env.example. Never commit credentials/.env/private attachments/customer data/volumes/dependencies/temp artefacts. .gitignore is a safeguard, not proof that staged content is safe.

Distinguish product requirements and architectural constraints from initial implementation choices, configurable operational defaults and example configuration. Dependency versions, pool sizes, cache algorithms, scanner products, timeouts and container mechanics are not immutable product decisions. Preserve security guarantees when making a documented implementation choice concrete. Annual FX Settings must remain a simple per-year rate form; internal audit/version details must not become mandatory user-facing workflows. Normal self-hosting uses one supported setup command to orchestrate privileged preparation. Upload security is mandatory, but a particular scanner is not; test configured scanner failures without making scanning a prerequisite for every deployment. Licence selection remains outstanding; do not add one without a separate decision.

Git history is the development audit trail. Use logical commits; inspect staged diff and tests. No unnecessary branches/remotes/PR/publishing workflow. Baseline documentation/bootstrap commit must be clean before major implementation. Release versions, migration versions and image digests must be traceable; do not alter applied migrations or require manual DB surgery for normal upgrades.

Maintain the public repository and its `/docs` wiki together under ADR-010. Never publish customer data, credentials or private operational records. Repository content must be self-contained project documentation: product behaviour, architectural rationale, implementation requirements and verified technical status. Exclude conversational narrative, personal instructions and internal setup records.

Self-hostability is part of done. A feature fails done if it requires undeclared development-host configuration. Documented clone/configure/setup/Compose/owner journey must work on a clean host, preserve volumes, recover and upgrade. Run relevant tests, record pass/fail/not-run honestly, update verification evidence. Do not replace failing tests with weaker assertions or claim document checks prove application acceptance.

## Documentation editing discipline

Create or revise documentation one file at a time: read dependencies, draft, review for contradictions/omissions/scope, save and confirm completeness before beginning the next file. Do not batch or parallelise documentation generation.
