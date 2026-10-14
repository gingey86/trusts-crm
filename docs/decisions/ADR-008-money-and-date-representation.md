# ADR-008: Decimal money and date-only fundraising dates

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Binary floating-point can corrupt monetary calculations. Turning application deadlines into midnight timestamps can shift their date between timezones.

## Decision

Exact decimal storage and arithmetic are architectural constraints; binary floating-point money is prohibited. Initial implementation uses PostgreSQL numeric(20,4) amounts, numeric(20,10) rates, numeric(5,4) probability, Prisma Decimal and decimal.js. Probability is inclusive 0–1. ISO 4217 currency code is mandatory whenever amount is present; validate current supported codes and currency precision. Native decimal values cross JSON/CSV boundaries as strings. No converted total is authoritative stored native money. Reject negative grant/request values; zero is valid and distinct from unknown/null. Validate capacity before multiplication/aggregation and reject overflow.

The initial decimal.js configuration uses a dedicated constructor with 60 significant digits and ROUND_HALF_UP. Equivalent implementations may change that configuration only with evidence that supported operations retain precision. Construct values from strings; do not change shared global defaults or pass through Number. Preserve intermediate precision through conversion, weighting and aggregation; round only the final displayed/exported reporting amount to the reporting currency's minor-unit precision. Test values near the supported numeric bounds as well as ordinary amounts.

Fundraising dates use PostgreSQL date / Prisma DateTime @db.Date, validated YYYY-MM-DD at API boundaries. Central date helpers may use UTC solely to bridge the Prisma representation; never display those bridge values as local timestamps. Date-only values stay strings in client contracts. Start/end ranges are inclusive in product forms, except FinancialYear.endExclusive.

Audit, login, createdAt/updatedAt and security events use timestamptz and UTC ISO instants. Interaction's business occurrence date is date-only, with recording timestamp separately. Overdue uses organisation-local today from IANA timezone. No 24-hour millisecond arithmetic for calendar dates.

## Rationale

Exact decimal arithmetic and explicit temporal semantics make native values, FX and deadlines dependable.

## Alternatives considered

Float/double money: rejected. Integer minor units: valid but more currency-exponent bookkeeping than Decimal for this product. All dates as timestamps: rejected. Local server timezone: non-portable.

## Consequences

Money/date serializers, ISO currency validation, final half-up rounding, cross-timezone/DST/leap-day tests and explicit null handling are mandatory. FY rates follow ADR-002. No formatted money/date text stored in numeric/date columns.
