# Synthetic dataset specification

`seed-data.json` describes a wholly fictional scenario. All identities and organisation details are fabricated; email and website domains use `.invalid`. Fixtures contain no credentials or copied charity records. Validate them against the conceptual schema and the money/date rules before loading.

## Scenario

Primary fictional charity: Meadowbridge Learning Charity, supporting adult learning and education access. 24 fictional funders with varied themes/geography, statuses, grant sizes and application methods. Four synthetic role identities (Owner, Administrator, Fundraiser, Read-only). A second minimal isolation organisation is a security sentinel, not a second pilot business dataset; it shares selected record aliases/IDs with different content to prove isolation. Each lives in its own DB.

24 Opportunities cover all nine stages, native GBP/USD and EUR without a rate. Applications include pending decisions, successful awards, historical rejections and withdrawals. Two active Grants have structured obligations spread across dates/types. Contacts, dated affiliations, Interactions, designated next actions, overdue/future/completed Tasks, archived history, invitation-only status and a reapplication-until restriction exercise ordinary work.

Financial years use April start, explicit ranges FY2025/2026/2027. USD→GBP rates 0.75, 0.77, 0.80 respectively; no EUR→GBP. Money/rates/probabilities are strings. Reference today for deterministic tests: 2026-10-13 in Europe/London. Product uses actual organisation-local today; tests freeze time. Calendar dates intentionally span the whole year and next year. Future demos may add a documented shifted-date mode, never silently alter acceptance fixtures.

## Loader contract

Derive record UUIDs deterministically from a fixed fixture namespace, entity type and alias. For isolation tests, the same entity/alias in the primary and sentinel databases must produce the same record UUID; organisation IDs and user identities remain distinct. This tests whether tenant context, rather than globally unique record IDs, enforces access boundaries.

Identity aliases map to locally created Better Auth users through secure invitations or test setup; fixtures contain no password or MFA secret. `documents[].syntheticText` supplies exact UTF-8 contents for files generated into private storage. Compute their checksum and byte count and create the corresponding metadata and typed links.

Use `pnpm db:seed` only with APP_ENV development/test and `SYNTHETIC_DATA_ACK=synthetic-only`; reject production mode even when acknowledgement is present. Validate every FK, status/date/decimal and successful-Application/Grant link first. Seed known synthetic tenants only; fail rather than overwrite an unknown/live tenant. Repeated seed is idempotent. Destructive reset requires explicit synthetic-target verification and must not affect other databases. Never run seeding automatically at production startup.

## Known numeric acceptance probe

Filter `O22`, `O23`, `O24`: native GBP 10,000 at 0.5; USD 10,000 at 0.5; EUR 10,000 at 0.5, FY2026. Converted subtotal GBP 17,700 and weighted GBP 8,850; one EUR Opportunity excluded with EUR 10,000 native subtotal and EUR 5,000 weighted subtotal. Export metadata retains the FY2026 USD rate of 0.77 and its internal historical reference. Same-currency GBP uses identity rate. Changing FY2027 cannot change this result; deliberately editing FY2026 explains recalculation and preserves prior export basis without requiring a revision-management UI.

## Validation

Check all record references, date-only values, decimal strings, workflow states and award relationships. The dataset must retain all pipeline stages, mixed currencies, missing-rate handling, historical rejection, archived links, active grants, overdue and future tasks, invitation-only status and reapplication restrictions. Recorded interactions must not occur after the reference date; submitted applications must have coherent submission/deadline chronology. Active grants must be associated with current funders.

Generate oversized, malicious and traversal test inputs only in temporary synthetic test storage. They are separate security-test cases and do not belong in this sample dataset.

Retention tests may advance the test clock or create separate fictional historical cases beyond seven years, without shifting this acceptance dataset silently. Verify active/archived records, attachments, significant next-action/business audit and interpretation settings remain accessible and exportable; technical staging/export-package cleanup must leave their sources intact. These cases prove support for long-lived history, not automatic deletion at a threshold.
