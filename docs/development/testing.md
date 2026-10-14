# Testing strategy

Dependencies: security/threat-model, acceptance-tests and fixture specification. Tests protect actual risks; avoid tests that merely reproduce implementation. Never use real data or production endpoints.

## Layers

Vitest unit tests: decimal conversion/aggregation/rounding/missing basis, probability/null semantics, date-only/local-today/FY rules, permissions and lifecycle preconditions. Component tests: minimal creation, errors, conversion warnings and keyboard controls. Integration tests use real PostgreSQL with separate control and two tenant DBs, production-like restricted runtime roles, Storage temp roots and real Better Auth sessions; mocks cannot prove isolation or transactions. Playwright covers complete lifecycle, annual/monthly calendar, Settings FX, import/export/archive and role denials through UI plus direct requests.

Use pinned test time 2026-10-13/Europe-London for fixture assertions. Test UTC, Europe/London DST boundaries, America/Los_Angeles and Pacific/Auckland without shifting date-only deadlines. Include leap-day validation, fiscal boundaries and invalid dates. Money tests use Decimal strings, rounding edges, unknown/zero, overflow, different request/award currencies and FY revisions.

## Required adversarial cases

Concurrent mixed-tenant requests with identical record IDs; altered tenant/record IDs; unauthorised download/export/temp URL; cached response leaks; expired technical artefacts under configured policy; wrong-DB connection; disabled tenant/failed resolution; every role's denied mutation; admin ownership escalation; offboarding stale sessions; MFA enrolment/session bypass; CSRF/origin validation; path traversal/signature/oversized uploads and executable/public-serving denial; configured-scanner failure where applicable; formula injection; malformed/duplicate confirmed imports; stale edits and parallel grant conversion. Do not require a particular scanner product.

Audit checks verify required events/actors/reasons and no passwords/tokens/CRM body leakage. Tests try runtime audit mutation and provisioning privileges. Workflow transaction failure must leave no half-created Application/Grant or contradictory stage. Archive retains links and active-child visibility; restore/export preserve historic IDs, rate revisions and document checksums.

Use controlled clocks beyond seven years to prove canonical active/archived records, attachments, financial-year/FX interpretation and business audit remain usable and exportable without automatic archival or erasure. Run temporary-file, generated-package, cache and operational backup/log cleanup separately and prove source history survives. Test deliberate authorised erasure and its reapplication after restoration independently of record age. FX component tests use simple annual Settings, significant-change audit and historic export basis; internal version integrity tests do not imply a version-management UI.

## Execution contract

`pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm test:integration`, `pnpm test:e2e`, `pnpm build`. Implement separate vitest unit/integration configs and Playwright setup as part of v0.01. No-test suites must fail rather than pass as evidence. Bootstrap creates/reset only clearly named synthetic test DBs with an explicit test-mode guard. Run independent test tenants/workers or serialise stateful cases, never race fixture resets.

Clean-host portability through the normal one-command setup route, safe setup retry, persistent-volume survival, external DB configuration, offline-runtime independence and backup/restore need operational integration tests/manual evidence beyond browser tests. Ordinary bundled installation must not require manual role/provisioning commands or host Node/PostgreSQL. Before v0.1 test clean VM release install, upgrade/migration failure/retry and hosted-to-self-hosted exit. Use axe plus manual keyboard/focus/zoom/phone checks; automated accessibility tooling alone cannot prove readable annual calendar UX.

## Evidence and progression

Record version, commands, environment and pass/fail/not-run in docs/development/verification.md; keep sensitive logs outside Git. v0.01 passes its acceptance IDs; v0.05 passes production readiness including recovery/provisioning/privacy drills; v0.1 repeats release portability/upgrade/exit and pilot usability. Document validation does not establish application acceptance. Run targeted checks after changes, followed by the relevant release suite; broaden testing when failures or unresolved concerns justify it.
