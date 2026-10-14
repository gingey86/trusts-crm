# Scope and exclusions

Dependency: [product-spec](product-spec.md). Canonical as of 13 October 2026.

## Included

Funder relationships and contacts; opportunities and board/table pipeline; explicit applications and decisions; grants and structured obligations; tasks and next actions; interactions; private attachments; annual/monthly derived calendar; useful dashboard, search, filters and simple management reports; annual organisation-managed budgeting FX; organisation users/roles; CSV import and portable export; archival; audit; secure Docker Compose self-hosting and database-per-organisation hosting.

v0.01 implements a thin but complete version of this workflow using synthetic data. The roadmap defines production hardening without excusing insecure local authorisation or single-database shortcuts.

## Hard exclusions for v0.1

Do not implement, scaffold product screens for, or introduce dependencies solely for these features:

- Individual donors or major-donor cultivation, individual giving, fundraising appeals, recurring donations, Gift Aid, public donation forms, payment processing or direct debits.
- Events/ticketing, memberships, volunteers, beneficiaries, case management or website CMS.
- Mass email marketing, newsletters, social media integration, whole-inbox ingestion or sophisticated email synchronisation.
- Accounting integrations including Xero/QuickBooks, accounting FX gains/losses or live FX feeds.
- Automated funder discovery, grant databases, scraping or commercial research enrichment.
- AI grant writing, generated applications, assistants, chatbots or AI querying.
- Public API, Zapier, webhooks, complex workflow builders, custom objects, custom permission builders or configurable roles.
- Native mobile apps, advanced BI, donor/funder portals or SSO/passkeys.

Internal authenticated handlers are implementation details, not a public integration API. Recording an Interaction of type Event does not create event management. Payment-request Obligations and dated grant instalments record fundraising commitments; they never execute payments or constitute accounting.

## Deferred within the product's possible future

Configurable stages, saved views, constrained custom fields, recurring obligations, richer payment schedules/reports, relationship mapping, Google/Microsoft calendar integration, selective email capture, duplicate detection and polished one-click organisation export. None is a v0.1 dependency. Basic full data portability is already required; the deferred item is polish, not the ability to leave.

## Minimal choices

Fixed vocabulary and roles; manual probability; free-text purpose/project rather than a separate project-management module; thematic/geographic interests as simple tags; manually recorded payment milestones; derived in-app reminders rather than a notification engine. No separate daily/weekly agenda. Do not add background workers, queues or microservices unless a demonstrated core requirement cannot be served by the monolith.

## Change control

A feature must materially help research, cultivate, apply to, manage or report to a trust/foundation, simplify work and preserve clarity/security/ownership. If removing it would not materially weaken that workflow, omit it. Routine engineering choices remain the implementer's responsibility. A scope change requires an explicit owner decision and updates to product-spec, the relevant ADR, roadmap and acceptance tests before implementation.
