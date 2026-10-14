# Privacy and data handling

Status: operational design, not a legal contract. Dependencies: security-baseline and operations runbooks. Hosted charity normally controls CRM content; hosted service processes it on documented instructions. Before real pilot data, confirm actual responsibilities, processor terms, authorised contacts, providers/locations and controller retention instructions.

## Data minimisation and environments

Store only fundraising-relevant contact/relationship information. No beneficiary casework or sensitive dossiers. Do not log document contents, contact text or full request bodies. Self-host telemetry is absent. Development, automated tests, demonstrations and ordinary staging use synthetic data exclusively. Exceptional recovery testing with real data uses a separately approved secured production-grade recovery environment, scoped access and documented removal of recovery copies.

## Organisation-controlled CRM retention

Trusts CRM preserves long-lived institutional memory. It must support at least a seven-year audit horizon for relevant records and longer where the organisation requires it. This is a capability requirement, not a universal legal claim or deletion threshold. The organisation determines retention and deliberate erasure in light of its accounting/audit needs, grant agreements, reporting, reapplication restrictions, relationship history and applicable obligations.

Canonical CRM information must never be automatically deleted, purged, expired or archived because it reaches a particular age. This includes Funders, Contacts and affiliation history, Opportunities, Applications, decisions/feedback, Grants, Obligations and reporting history, Interactions, relevant Tasks and next-action history, Documents/attachments, interpretation settings, financial years, budget FX history, appropriate business audit and archive metadata. Archive changes visibility; it is not deletion.

## Separate operational policies

| Data | Rule |
| --- | --- |
| Active/archived CRM, attachments and business AuditEvent history | organisation-controlled retention; no age-based expiry |
| Temporary upload staging, transient CSV files, generated export packages and caches | configurable cleanup based on processing/security needs; never remove source CRM records or retained attachments |
| Redacted application/infrastructure logs | bounded rotation under documented deployment policy; distinct from business audit |
| Authentication/security telemetry | deployment policy appropriate to its purpose; preserve significant membership/business events needed to interpret CRM history |
| Encrypted recovery backups | separate disaster-recovery schedule; managed policy established before production, self-hosted policy chosen by administrator |
| Offboarded auth credentials/sessions | revoke immediately; remove unnecessary identity data through controlled process; preserve minimal actor attribution when justified |

Operational timeout and rotation values are configurable policy, not immutable product requirements. Document their purpose and selected values before production. Customer export includes retained appropriate business audit; no passwords, tokens or another customer's logs. Contact correction/erasure is an authenticated controller-instructed process preserving justified attribution and relationship integrity where needed.

## User and organisation deletion

Owner/Administrator offboards users: deactivate membership, revoke sessions/tokens, reassign open tasks/ownership and preserve historical actor references. Owner transfer must complete before last Owner offboarding. Removing membership from A must not delete membership of B.

Organisation closure: verify authorised instruction, offer complete export, agree cut-off and any justified retention requirements, disable routing/revoke users, carry out authorised live-data erasure, minimise control metadata and record completion. Keep minimal deletion markers outside erased CRM for as long as recoverable copies require them. Backup handling follows the declared deployment policy and controller instructions; restored older backups must reapply erasure before any user access. Report live erasure and remaining recovery-copy lifecycle separately. Do not impose a short CRM retention period to simplify backup handling.

## Subprocessors and location

Before production maintain an inventory of VPS, backup destination, transactional mail, optional DNS/proxy and any support provider: purpose, country/region, what data they receive, safeguards, terms and owner approval. Prefer UK/EU locations consistent with commitments; do not assume a provider's brand proves location. Attachments/local auth/search add no SaaS subprocessor. Optional Cloudflare is neither required nor silently enabled. Record changes before adopting a provider.

## Incident and access model

Normal operators view redacted health/version/routing metadata. Exceptional CRM access follows support-and-production-access.md. Incidents follow incidents.md: contain, preserve evidence, record timing/affected tenants, promptly inform controllers and assist their assessments/notifications. Controller and processor obligations are distinct; no blanket claim that only reportable incidents matter to the controller.

Sources checked 13 October 2026: [ICO processor-contract requirements](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/contracts-and-liabilities-between-controllers-and-processors-multi/what-needs-to-be-included-in-the-contract/), [ICO breach guidance](https://ico.org.uk/for-organisations/report-a-breach/personal-data-breach/personal-data-breaches-a-guide/). Verify current guidance and service terms at the real-data gate.
