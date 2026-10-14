# Acceptance tests

Dependencies: product/workflows/UI, architecture/ADRs, security, operational runbooks and fixtures. Each criterion is observable; implementation records evidence rather than declaring success by checklist alone. All v0.01 cases use fictional data and a fixed clock. Required v0.01 IDs: A01–A16. Hardening/pilot gates: A17–A22.

## Core journey

| ID | Given / action | Required outcome |
| --- | --- | --- |
| A01 | Fresh local control DB and two synthetic tenant DBs; bootstrap verified users | real Better Auth login and correct memberships; invalid tenant fails closed; no public signup/default DB fallback |
| A02 | Fundraiser creates Funder by name, Contact and USD Opportunity | fast minimal forms, linked pages, create-first defaults; native decimals retained, GBP conversion labelled with FY/rate |
| A03 | Add Interaction and follow-up; designate Opportunity next action | funder history updates; one linked Task/next action, one calendar event; completion, cancellation and archival each clear designation |
| A04 | Set deadline/planned submission/expected decision; advance working stages | annual and month events derive immediately, filters work, selecting opens source; keyboard move is available |
| A05 | Submit with requested amount/date and private document | explicit linked Application, stage Submitted, copied submission facts; one expected-decision event; double submit does not duplicate |
| A06 | Successful decision with award → Create grant twice | stage Won, actual decision/award retained; exactly one Grant with owner/purpose/contacts/doc links carried forward; no duplicate bytes |
| A07 | Add/report/complete structured Obligations then Grant | dashboard/calendar obligations; derived overdue; Grant completion blocked until all Complete/Not required; completion retains evidence/history |
| A08 | Rejected/withdrawn and archived historic Applications | Lost/Withdrawn correct, feedback retained; funder history shows prior attempts; new ask uses a new Opportunity |

## Cross-cutting v0.01 requirements

| ID | Test | Required outcome |
| --- | --- | --- |
| A09 | Filter fixture O22/O23/O24 at FY2026 | GBP converted subtotal 17,700; weighted 8,850; EUR 10,000 / weighted 5,000 excluded with missing-rate flag/count; native records save |
| A10 | Administrator edits USD rate in annual Settings, adds FY2027, changes reporting target | simple year/rate form; Fundraiser direct request denied; existing-year recalculation explained and significant change audited; no required revision-management/impact-preview flow; new-year rate cannot affect FY2026; old export basis reproducible; missing target rates flagged |
| A11 | Annual/monthly date derivation and display | all source types, no duplicate next actions/submissions/decisions, date edits reflected; source date same across timezone/DST; history toggle and active child of archived parent correct |
| A12 | Each role, unauthenticated user, offboarded user | policy matrix enforced via direct requests too; Admin cannot grant Owner; Read-only cannot mutate; stale sessions revoked; synthetic MFA/recovery path tested |
| A13 | Tenant A/B same IDs, concurrent requests/cache, guessed files/export/temp paths | no cross-tenant contents/metadata; wrong DB credentials denied; no default fallback; disabled tenant denied; tenant-scoped artefact cleanup |
| A14 | CSV import Funders/Contacts/Opportunities | map/preview/validate/confirm; amounts/currencies preserved; valid parent references; invalid file changes nothing; duplicate confirmation idempotent; no silent skips |
| A15 | Export/archive/unarchive/private files; historical records beyond seven years; technical cleanup | all structured domain/settings/rates/business audit/archived links export; retained attachments and significant next-action history remain usable; no age-based deletion or automatic archival; cleanup removes only technical artefacts; manifest/checksums and authorised retrieval; machine-readable reimport path; active children stay visible; no normal hard delete |
| A16 | Clean Docker-host normal installation from README/env through one setup command, Compose startup and owner completion; change port/path and recreate app | setup orchestrates control/tenant migrations, restricted roles and first owner without manual internal commands, source edits, host Node or host DB; safe retry preserves secrets/data; persistent DB/files survive; self-host auth/control works with managed endpoints blocked; no development-host prerequisites; synthetic seed refuses production |

## Production and pilot gates

| ID | Milestone | Required evidence |
| --- | --- | --- |
| A17 | v0.05 | Production HTTPS, verified email/recovery, privileged MFA enforcement, configured CSRF/session/rate controls, private size/path/MIME/signature-validated uploads, no executable/public serving, documented deployment-appropriate malware controls; configured-scanner failure denies affected uploads; no scanner product prerequisite; secret/log redaction and applicable dependency checks |
| A18 | v0.05 | Idempotent tenant provisioning; failed setup non-routable; restricted roles; migration version tracking, failure/retry, no manual DB surgery |
| A19 | v0.05 | Encrypted independent backups under declared deployment schedule/retention; whole-service and isolated one-tenant restore verified/checksummed; B unaffected by A restore; deliberate erasure reapplied before restored access and recovery-copy lifecycle proven; backup rotation does not erase source CRM history |
| A20 | v0.05 | Full hosted-to-self-host export/restore into clean instance without manual reconstruction: organisation/record IDs, links, settings, rates, audit and bytes match; scoped membership roster and historical actor attribution retained; fresh authentication accounts, organisation-ID collisions rejected, no other-tenant/auth secrets |
| A21 | v0.05 | Secured managed production environment; privacy retention/deletion/offboarding/subprocessor/location/incident/support procedures assigned; synthetic drills completed; measured capacity, bounded storage/log growth and documented infrastructure dependencies |
| A22 | v0.1 | Versioned release clean-VM install and upgrade/recovery proof, external PostgreSQL path, accessible annual workload with 150+ events, phone/keyboard usability and real fundraiser acceptance; no excluded feature classes |

## Manual usability evidence

Test minimal record creation without instructional walkthrough; funder history intelligible; no giant form/wizard; annual calendar readable at realistic density and 200% zoom; filters/overflow/source links usable by keyboard and on phone. Test missing conversion warnings with unknown values so partial totals cannot look complete. Review reports' decision-period success-rate denominator and Grant-based award totals to avoid double counting.

Money unit tests must include high-value multiplication and final rounding: `9999999999999999.99 × 0.1234567890` retains `1234567889999999.998765432110` before rounding to GBP `1234567890000000.00`. Test aggregate overflow and rejection at storage boundaries; never silently truncate or use binary floating-point intermediates.

## Import contract clarification

Support explicit CSV external keys/parent references: Funder `external_key,name`; Contact `external_key,funder_external_key,name`; Opportunity `external_key,funder_external_key,title,amount,currency,planning_year,stage`. Optional known columns map in preview. Resolve references only in current tenant; ambiguous names require explicit selection. Imported terminal/submitted stages require consistent Application history and therefore cannot be manufactured by the Opportunity-only importer; reject such rows with an explanation. Full historical migration uses lossless organisation restore. Keep existing source values available for correction.
