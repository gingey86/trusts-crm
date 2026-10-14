# Security incidents and breach response

Dependencies: security-baseline, privacy-and-data-handling and support access. This is an operational procedure, not a replacement for controller/processor terms or current legal guidance.

## Response sequence

1. Open a restricted incident record with discovery time (UTC), reporter, symptoms, suspected tenants/systems and named response owner. Preserve evidence in authorised operational storage. Customer data and private incident evidence must not enter public repositories or unsecured communication channels.
2. Contain proportionately: disable affected route/account, revoke sessions/credentials, quarantine files or restrict network access. Preserve redacted logs/checksums and relevant evidence before destructive cleanup. Exceptional operator access remains attributable and reasoned.
3. Determine scope: confidentiality, integrity or availability impact; data categories, affected tenants/users, time window, probable cause and ongoing exposure. Treat lost/corrupt data as potential personal-data incidents too.
4. Inform affected controllers without undue delay when aware of a personal-data breach; provide known facts promptly and follow-up updates rather than waiting for a perfect investigation. Record notifications and timing. The controller assesses regulator/data-subject notification obligations with assistance from the processor. Notifiable controller breaches generally have a 72-hour ICO deadline from awareness; consult current guidance rather than treating that as permission for processor delay.
5. Recover using tested restore/redeployment, rotate secrets, validate isolation/permissions and confirm the attack path is closed. Do not restore deleted customer data or resume vulnerable versions blindly.
6. Record cause, actions, residual risk and completion; add regression tests and update wiki/threat model/ADRs where warranted. Keep private evidence out of repository; publish only non-sensitive engineering corrections.

## Before real data

Assign the response owner and controller contact for each tenant, escalation route, backup/key custodian and provider contacts. Test a synthetic incident involving cross-tenant file access, credential compromise and failed recovery. Verify rapid contact capability outside normal support cycles; a document with unassigned response responsibility does not pass the gate.

Source checked 13 October 2026: [ICO personal-data breach guide](https://ico.org.uk/for-organisations/report-a-breach/personal-data-breach/personal-data-breaches-a-guide/), [ICO processor notification](https://ico.org.uk/for-organisations/the-guide-to-nis/nis-and-the-uk-gdpr/). Re-check before pilot and when legal guidance changes.
