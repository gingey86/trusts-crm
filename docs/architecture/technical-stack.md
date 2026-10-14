# Technical stack

Dependencies: product specification and ADR-001–008. Conventional TypeScript monolith; no host-specific infrastructure.

| Area | Choice | Boundary |
| --- | --- | --- |
| Runtime | Supported Node.js LTS, pnpm | Same resolved runtime locally and in container; lock install-generated dependencies |
| Web | Next.js App Router, React, TypeScript | Node runtime for DB/auth/storage; no edge-only dependency |
| DB | PostgreSQL, Prisma | Separate generated control/tenant clients and migration trees |
| Auth | Better Auth, Prisma adapter, two-factor plugin | ADR-006; do not implement crypto/auth mechanics |
| UI | shadcn/ui source components, Radix, Tailwind CSS | Accessible primitives; install selected components only |
| Calendar | FullCalendar standard React/core/dayGrid/multiMonth | Annual and month views without mandatory commercial plugin; package versions aligned |
| Validation/calculation | Zod, decimal.js, date-fns | Decimal strings and explicit date helpers |
| CSV/mail | csv-parse/stringify, Nodemailer | CSV preview and transactional SMTP only |
| Tests | Vitest, Testing Library, Playwright, axe | Real PostgreSQL isolation tests, not SQLite substitutes |
| Deployment | Docker Compose v2 | Container PostgreSQL or configured external PostgreSQL |

The package manifest and container templates specify initial candidate versions, not immutable architecture. Their combined compatibility has not yet been verified. The first implementation build must check maintenance status, security advisories and peer dependencies, then generate and commit a lockfile through a successful pnpm installation. Record the resolved runtime, database and dependency versions together when tested; no exact patch/minor version is a product requirement.

The implementation uses src/app for routes, src/components for UI, src/server for authentication, tenant context, repositories and services, src/lib for money/date/validation helpers, prisma/control and prisma/tenant for schemas and migrations, scripts for operator commands, and tests. These directories and database migrations remain to be implemented.

Server components may render; mutations go through shared policy/service boundaries whether invoked by route handlers or server actions. No DB/storage clients in browser bundles. Parameterised queries, transactions and constrained typed joins. Use PostgreSQL text search/ILIKE with pagination initially, no external search engine. Do not cache authenticated cross-tenant data globally.

The Dockerfile's initial implementation design uses a multi-stage build with Next standalone output, a non-root application runtime and a separate operator target. Setup tooling orchestrates privileged preparation without exposing its individual commands to ordinary self-hosters. Operator credentials are excluded from the application. Container targets and client-cache algorithms are implementation choices; privilege separation, bounded resources and portable Compose deployment are constraints. v0.01 uses source builds; versioned images may be distributed for v0.1 using the same configuration contract. Queues, Kubernetes, Redis and external search services are not required by the current design.

Integration references: [Next installation](https://nextjs.org/docs/app/getting-started/installation), [Better Auth/Prisma guide](https://www.prisma.io/docs/guides/authentication/better-auth/nextjs), [FullCalendar v6](https://legacy.fullcalendar.io/v6/multimonth-grid). Use the documentation for the installed versions when implementing integrations.
