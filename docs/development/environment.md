# Development environment and implementation bootstrap

Dependencies: deployment/self-hosting, technical-stack, fixtures/synthetic-data-spec. Development infrastructure is never an application dependency. Development and ordinary testing use only synthetic data; no production DB URLs, files, backups or credentials.

## Starting state

This repository is a pre-build documentation/bootstrap baseline. It contains no implemented Next routes, Prisma schema/migrations, operator scripts or test suite. package.json lists required dependencies/scripts to implement; scripts pointing to missing source are contracts, not working features. Compose can start bundled PostgreSQL/mail independently; app build requires implementation. README/verification must reflect that distinction until it changes.

## Implementation order

1. Read docs/README, product docs, ADRs, architecture/security and v0.01 acceptance. Confirm clean Git baseline. Validate the candidate Node/pnpm and dependency versions through normal `pnpm install`; commit the generated pnpm-lock.yaml only after success. Review advisories and compatibility, align container/runtime versions and record the resolved choices; no fabricated lock.
2. Create Next/TypeScript/Tailwind/shadcn source and test configs; separate prisma/control/tenant schemas/migrations/generated clients. Generate Better Auth models from the installed library. Implement startup env validation, the normal single-command setup wrapper/internal orchestrator, advanced operator commands, health/version endpoints and Dockerfile with non-root runtime.
3. Implement tenant context/restricted credentials and server role policy before domain handlers. Prove two synthetic DBs and no fallback. Build money/date helpers and transactional domain services.
4. Implement complete lifecycle, useful views/calendar, storage/import/export/archive, fixtures and acceptance tests. Add UI progressively without weakening boundaries.
5. Run clean-host Compose install and app recreation, update docs to actual commands/assumptions and record evidence. v0.01 is complete only when required acceptance passes.

## Development command contract

The normal self-hosting command contract is `./scripts/setup.sh`, implemented using Docker/Compose with an internal `pnpm setup` orchestrator. It prepares private configuration, database roles/migrations, the first organisation and owner safely; no host Node installation is required for this route. Developer commands are `pnpm dev`, `build`, `start`, `lint` (explicit ESLint), `typecheck`, `test`, `test:integration`, `test:e2e`. Advanced internal commands are `setup:database`, `db:generate`, `db:migrate`, `db:seed`, `tenant:create`, `owner:bootstrap`, `tenant:export`, `tenant:restore`. Define script files/config alongside implementation; these names/mechanics are initial implementation contracts, not immutable architecture. Local development can run in containers to avoid exposing PostgreSQL; a host Node workflow may use a deliberate loopback-only dev DB override, documented and ignored, never a pre-existing host DB.

Copy .env.example privately, configure random local secrets and development mail capture. Do not commit .env or generated state. Seed acknowledgement permits synthetic data only. Test identity credentials are generated locally via auth setup and never saved to fixtures. Test database creation/reset must assert test namespace/mode before destructive actions.

## Git/wiki discipline

Use logical commits grouping coherent implementation, relevant tests and wiki changes. Stage explicit reviewed paths; inspect staged diff for secrets/real data. Keep /docs canonical; read relevant documents before behaviour/architecture edits. New durable decision gets an ADR; supersede historical ADRs without rewriting reasoning. No branch/remote/provider workflow is needed until useful. Versioned releases/images come later.

## Definition of done

Feature works through the documented normal setup on clean Docker-capable Linux, respects role/tenant boundaries, retains money/date and long-term-history integrity, survives app recreation, includes relevant tests and aligned docs. No convenience-only development-host paths, undeclared network/credentials or managed-service dependency. Record unavailable tests/dependencies honestly; passing document validation is not passing application acceptance.
