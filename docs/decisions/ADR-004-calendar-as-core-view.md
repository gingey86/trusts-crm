# ADR-004: Annual/monthly calendar as a core view

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Fundraisers plan across a year. Pipeline stage alone cannot expose deadlines and grant commitments. An annual overview with monthly detail reflects the fundraising planning horizon.

## Decision

Calendar and Pipeline are first-class primary navigation. Default twelve-month annual overview with month drill-down, type/owner/status filters, accessible overflow and year event list. Use the standard MIT FullCalendar v6 multiMonthYear/dayGridMonth plugins initially; no paid Scheduler dependency. If that major becomes unsuitable, replace behind the calendar UI adapter and document the change.

Events are read projections from Opportunity, Application, Grant, Obligation and Task dates. Stable ID is source type + source ID + date field. No writable CalendarEvent table. A Task designated next action renders once. Application owns submission/decision dates after submission. Active child records stay visible even when their parent is archived. Completed/archived source events require history mode.

## Rationale

One source date prevents drift. Annual visibility makes workload and funder cycles legible.

## Alternatives considered

Daily/weekly agenda: too narrow. Separately maintained calendar: duplicate work. External-calendar-first design: proprietary dependency and synchronisation scope creep. Premium calendar plugins: unnecessary.

## Consequences

Readability at 150+ annual events, phone/keyboard navigation and date-change derivation are acceptance criteria. External calendar synchronisation remains deferred. Source edits refresh calendar projections; date-only values never shift across timezones.

Sources checked 13 October 2026: [standard licence](https://fullcalendar.io/license), [v6 annual grid](https://legacy.fullcalendar.io/v6/multimonth-grid).
