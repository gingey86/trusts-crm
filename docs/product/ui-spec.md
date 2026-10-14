# UI specification

Dependencies: product-spec, scope-and-exclusions, workflows. British English; trusts/foundations vocabulary. Responsive productivity application built with shadcn/ui, restrained spacing/colour and semantic controls. Target WCAG 2.2 AA. Colour never carries status alone.

## Shell and navigation

Desktop left navigation: Dashboard, Pipeline, Calendar, Funders, Grants, Tasks, Search, Settings. Top bar has organisation identity, search shortcut and user menu. Phone navigation is a compact accessible menu; tables have purposeful horizontal scrolling or essential-column cards. Every detail page has breadcrumbs and direct links to related records. Preserve list filters when returning. No enterprise sales terminology, decorative analytics, giant forms or excessive nested tabs.

## Views

| View | Required content and actions |
| --- | --- |
| Dashboard | My overdue/upcoming tasks, deadlines/obligations, pending decisions, pipeline/weighted totals, stage counts, active grants and transparent attention flags |
| Pipeline | Board/table toggle; owner, stage, funder, year, currency and value filters; fast create; card title/funder, native amount, planning conversion, owner, deadline and next action |
| Calendar | Default annual view; year navigation; month drill-down; type/owner/funder/stage/status filters; date-labelled overflow lists; source record links |
| Funders | Searchable sortable table with name, status, owner, interests, last interaction, next action; archived toggle; create/import |
| Grants | Status/owner/period filters; awarded native/reporting values; period and next obligation; grant detail with all obligations |
| Tasks | Linked fundraising context, owner, due date and priority; overdue/upcoming/completed filters; inline completion and source links |
| Search | Type-labelled results and snippets; permission-scoped; archived opt-in; keyboard access |
| Settings | Organisation, financial years/currency/FX, users/roles, audit and import/export; controls hidden or disabled by role with clear explanations |

## Record pages and creation

Funder page is a relationship hub: summary, eligibility warnings and next action above current opportunities/grants, contacts, interactions, historical applications/grants and documents. Use sections with anchors, not an array of isolated tabs. Opportunity shows dates, ask, probability, stage, contacts, tasks, attachments and linked Application. Application shows immutable submission facts plus editable pending decision details and explicit outcome/grant actions. Grant shows award, dates and obligations; completion explains outstanding requirements.

Quick create Funder: name. Opportunity: title and funder. Contact: name and funder. Task: title with current owner. More fields are optional expandable sections; lifecycle actions ask only for required missing facts. Forms retain input on error, show field errors and focus the first invalid field. Prevent accidental double submissions. Edit conflict prompts reload/reapply rather than overwriting another user's change.

An Interaction can be added from a Funder with type, date and summary, optional contacts and follow-up Task. Document uploads show progress, validation errors and a private download action. Archive actions explain child/historical impact and require confirmation; no ordinary Delete control.

## Calendar readability contract

Use a twelve-month grid on desktop and stacked months on narrow screens, never tiny unreadable year cells. Show short type-labelled items and counts; overflow opens a date-labelled list linking to records. Offer a keyboard-accessible year event list alongside the visual grid. Month view shows fuller titles. No daily/weekly agenda is the centre of the design. Record date changes immediately refresh derived events. No calendar create/drag that maintains a second date source.

Defaults hide archived source records and completed Tasks/Obligations; explicit Include history reveals them with labelled status. An active child of an archived parent remains visible with an archived-parent badge. Planned submission is suppressed once actual submission exists; expected decisions are suppressed after a decision unless history is enabled. Calendar does not manufacture midnight timestamps from date-only values.

### Event sources

| Event | Source field | Display rule |
| --- | --- | --- |
| Application deadline | Opportunity.applicationDeadline | Show for active opportunities; terminal opportunity dates are available in history mode |
| Planned submission | Opportunity.plannedSubmissionDate | Show until an Application has an actual submission date |
| Actual submission | Application.submittedDate | Use the Application date; never emit a copied Opportunity date |
| Expected decision | Opportunity.expectedDecisionDate before submission; Application.expectedDecisionDate afterwards | Transfer date ownership on submission and emit one event; hide after a decision unless history is included |
| Recorded decision | Application.decisionDate | Show in history mode |
| Grant start/end | Grant.startDate and Grant.endDate | Emit separately labelled date events |
| Reporting, payment or renewal requirement | Obligation.dueDate | Label by obligation type; completed/not-required obligations appear in history mode |
| Task or next action | Task.dueDate | Emit once per Task; a next-action designation changes its label/style, not its date source |

Null dates produce no event. Event identifiers use record type, record ID and field. Filters apply to the source record and its linked funder/owner. Funder eligibility and reapplication restrictions remain reference information; a scheduled reapplication action uses a Task or Obligation.

## Reporting presentation

Conversions identify reporting currency and planning year, with the applied annual rate available in useful details. Settings presents a simple financial-year rate table, for example “FY2027: USD 1 = GBP 0.77”; saving a changed rate explains recalculation for that year. Internal revision identifiers, version management and separate impact-preview flows are not required UI. Unknown amount/probability displays Unknown; missing rate displays Conversion unavailable. Totals show converted subtotal plus counts/native subtotals excluded for missing rates/amounts/probabilities. Never show a misleading complete-looking figure. Pipeline totals exclude Won, Lost, Withdrawn and archived Opportunities by default; awarded figures use Grants to avoid double counting.

Initial configurable attention defaults are an upcoming window of 30 days, 180 days without meaningful interaction on a Current funder, and 60 days of inactivity on a non-terminal Opportunity, alongside missing/overdue next actions. These are initial usability choices, not retention policy or fixed architecture. Organisation administrators can change the thresholds in Settings; rules are explained beside flags. Inactivity uses last business edit or Interaction, not page views. Flags never automatically archive or erase records, and long-lived relationships remain accessible.

## Access and empty/error states

Read-only users see no working mutation controls; server denial still applies. Admin-only FX/user/export controls explain the boundary. Loading, no-results, empty, validation, missing conversion and failure states are distinct. Empty states offer the smallest permitted next action. Permission errors reveal no foreign record names. Keyboard alternatives exist for board moves and every calendar action; test at 200% zoom and phone width.
