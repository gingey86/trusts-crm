# ADR-002: Organisation-managed annual budget FX

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Organisations plan grants in different currencies using their own annual budget assumptions. Native values and historical reporting must survive rate changes.

## Decision

Owner/Administrator edits annual rates through Settings, for example “FY2027: USD 1 = GBP 0.77”. Rates are keyed by financial year, source ISO currency and reporting ISO currency. A positive decimal multiplier means one source unit equals rate target units. No triangulation, automatic inverse or live feed. Same-currency conversion is exactly 1 and requires no configured rate. Internal immutable rate history is an initial implementation choice for auditability and reproducible exports; revision identifiers are not part of the ordinary configuration workflow.

Every money-bearing record carries an explicit planningFinancialYearId; default current year is editable with confirmation. FinancialYear has immutable inclusive start/exclusive end dates and a label using its starting year (FY2026 = 1 April 2026–31 March 2027 for an April organisation). Years cannot overlap. Organisation financial-year-setting changes affect newly created years, not existing boundaries.

New-year rates cannot alter old-year figures. Saving a change to an existing year's rate explains that current planning figures for that year will recalculate and records the change in business audit. A separate impact-preview workflow is not required. Export metadata preserves the applied rate and as-of basis so an old exported report remains reproducible. Changing reporting currency clearly explains the new target; native amounts never change and missing new-target rates remain missing. Users need not manage rate versions.

Missing rate permits storage and yields null converted value with reason. Converted totals exclude unavailable items and show counts and native subtotals. Unknown amounts/probabilities are separately flagged. Decimal calculations round only final displayed/exported currency values using half-up and the ISO minor-unit exponent; aggregate before rounding.

## Rationale

Explicit year/rate basis makes management assumptions explainable without rewriting submitted asks or awards.

## Alternatives considered

Live feeds, hidden operator settings, global rates and automatic inverse rates: rejected. Freezing every screen conversion permanently at record creation: would frustrate deliberate budget revisions. Recalculating all years from the newest rate: historically misleading.

## Consequences

Simple annual-rate Settings, significant-change audit and historical reproducibility tests are required. Reporting identifies the planning year and reporting currency; useful rate details are available without exposing internal identifiers. Period filters do not implicitly choose the FX year. Test internal revision integrity where that implementation is used.
