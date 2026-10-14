# Trusts CRM product specification

Status: canonical pre-build specification; 13 October 2026. Target release: v0.1. First implementation: v0.01, synthetic data only.

## Specification authority

This specification defines the product requirements. v0.01 must prove authentication/roles, database routing, import/export and archive behaviour alongside the fundraising lifecycle. v0.05 hardens these capabilities for production. The calendar centres on annual and monthly views. Development and ordinary testing use synthetic data exclusively; real charity data requires the approved production environment.

For product behaviour use this document, scope-and-exclusions, ui-spec and workflows. Architecture documents and ADRs define implementation constraints. Acceptance tests make them verifiable. Resolve inconsistencies through reviewed documentation changes; implementation and specifications must remain aligned.

## Purpose

Trusts CRM is intended to be open source and freely self-hostable, exclusively for trusts and foundations fundraising. A licence must be selected and included before the first public software release. Keep the simplicity of Notion, but make this workflow native. Intended users currently rely on spreadsheets, Notion, Airtable, shared documents and personal memory. A small team must be able to begin without a specialist CRM administrator.

The software is intended for free self-hosting, with an optional managed hosting service. Both deployment modes use the same codebase. The application must work without Cloudflare or a proprietary hosted dependency.

Required infrastructure is documented in operations/infrastructure.md. Each organisation owns its CRM data. Complete export and compatible hosted/self-hosted models must permit migration without manual record reconstruction. A self-hosted instance operates its own control/auth database and does not depend on the managed service, licence validation or mandatory telemetry.

## Required domain and behaviour

| Record | Purpose |
| --- | --- |
| Organisation | Charity, reporting currency, timezone, financial-year settings and users |
| Funder | Relationship hub, eligibility, restrictions and full history |
| Contact | Person associated with a funder; historical associations retained |
| Opportunity | Potential ask, owner, purpose, pipeline stage, probability and next action |
| Application | Explicit submission linked to an Opportunity, with decision and feedback |
| Grant | Explicit award created from a successful Application |
| Obligation | Structured grant requirement, responsible user and due date |
| Task | Lightweight action or designated next action linked to relevant records |
| Interaction | Meaningful relationship history, optionally creating follow-up work |
| Document | Private attachment metadata, with bytes outside PostgreSQL |

Pipeline stages: Research, Qualified, Cultivation, Preparing, Submitted, Decision due, Won, Lost, Withdrawn. Fixed defaults for v0.1. Pipeline offers board and table. Formal submission and outcome changes use lifecycle actions, not unrestricted drag-and-drop into terminal stages. Rejected applications remain visible in funder history.

Funder statuses: Prospect, Active prospect, Current funder, Previous funder, Not currently eligible, Do not pursue. Archival is a separate property for every ordinary record. Grants: Awaiting agreement, Active, Reporting, Complete, Closed early. Obligation stored statuses: Upcoming, In progress, Submitted, Complete, Not required; Overdue is derived. Tasks: Open, Complete, Cancelled.

## Primary working views

Dashboard, Pipeline, Calendar, Funders, Grants, Tasks, Search, Settings. Pipeline and Calendar are equal primary views. The annual calendar opens by default and has a month drill-down. Events derive from source dates, never separately maintained. It covers deadlines, planned/actual submission, expected decisions, grant dates, obligations and dated tasks/next actions. Completed/archived history can be included deliberately.

The dashboard prioritises overdue/upcoming actions and obligations, pending decisions, transparent relationship-attention flags and pipeline figures. Search finds funders, contacts, opportunities, applications, grants and relevant notes. Tables filter by owner, status, date, funder and applicable currency/value. Phone use supports checking records/calendar, logging interactions, notes and task completion. No native app.

## Money, reporting and historical integrity

Always retain decimal native amount plus ISO currency. Each organisation sets reporting currency and annual budget FX through Settings. Rates are source-to-reporting multipliers keyed by financial year; no market feeds. Missing rates allow native saving, show an explicit warning and exclude that record from converted totals with counts/native subtotals. Weighted value is amount × manually entered probability. Totals must never add unlike native currencies.

Records explicitly reference their planning financial year. Settings presents annual rates simply, for example “FY2027: USD 1 = GBP 0.77”. New-year rates do not change old-year results. Material changes are audit logged; deliberately changing an existing year's rate recalculates that year's planning figures with a clear explanation. Internal rate history preserves prior reporting/export bases without requiring users to manage revision identifiers. Requested and awarded values remain distinct. Dates normally use date-only values; security/audit uses UTC timestamps.

## Access, portability and retention

Owner, Administrator, Fundraiser and Read-only roles, enforced on every server operation. Mature authentication; hosted privileged users require MFA. Tenant business data belongs in one PostgreSQL database per organisation. The optional control database contains routing/auth/operational metadata only. Private attachments inherit parent access.

CSV import covers funders, contacts and opportunities with preview, mapping, validation and explicit confirmation. Export covers all structured domain data and private attachment retrieval with a manifest. Ordinary records archive and retain links; permanent erasure is a controlled operational privacy procedure.

The CRM supports long-lived institutional memory, including at least a seven-year audit horizon and longer where the organisation requires it. No canonical records, attachments, interpretation settings, financial-year/FX history or business audit are automatically deleted, expired or archived because of age. Seven years is a supported horizon, not a deletion threshold. The organisation controls retention and deliberate erasure. Technical artefact cleanup, log rotation and backup rotation are separate operational policies and must never remove canonical history.

Tenant boundaries also cover files, temporary uploads/exports, caches, jobs, backups, restores, logs and migration artefacts. Service operation grants no routine access to CRM contents; exceptional access is individually attributable, reasoned, constrained and logged. Hosted privacy operations must be ready before real data; synthetic data is the default outside production.

## Completion standard

v0.01 must demonstrate Funder → Opportunity → Application → Decision → Grant → Obligation → Completion with synthetic data, annual/monthly calendar, mixed currencies, administrator-managed rates, two-database routing isolation, role boundaries, import/export and archival. It is a working local prototype, not production readiness. v0.05 proves security, provisioning/migrations, backup/restore and deployment readiness; v0.1 is the controlled real-data pilot after the production gate.

Required management outputs by v0.1: pipeline/weighted totals and stage counts; submitted applications in a period; decided-application success rate; awarded value in a period; active grants; upcoming obligations. Exclude pending/withdrawn applications from the success-rate denominator and label the period as decision-date based. In-app reminders are derived lists; email marketing and inbox synchronisation are excluded.
