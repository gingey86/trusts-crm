# ADR-005: Narrow product scope and canonical wiki

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Mainstream charity CRMs create expense and complexity by serving unrelated workflows. Product boundaries and architectural decisions need durable version-controlled documentation aligned with implementation.

## Decision

Build only trusts/foundations fundraising. Apply docs/product/scope-and-exclusions.md to every release proposal. Self-hosting and managed hosting use the same codebase, without a mandatory proprietary service dependency.

The /docs Markdown wiki is authoritative and versioned alongside code. Product, architecture, security, development, operations, roadmap and decisions all live there. Root bootstrap files and schema/fixtures are linked supporting implementation artefacts.

Code and relevant wiki changes belong in the same logical change. Durable architectural/product decisions use numbered ADRs including status, context, decision, rationale, alternatives, consequences and supersession links. Changed decisions get a new ADR; preserve historical reasoning and mark the old one superseded. Routine refinements update the relevant live document.

## Rationale

Scope discipline preserves the product's usefulness and operating cost. Git review/history makes decisions and implementation traceable across coding sessions.

## Alternatives considered

General charity CRM: rejected. Disconnected wiki services and unversioned documents: rejected because they separate specifications from implementation history. Rewriting past ADRs when decisions change: rejected because it obscures the development audit trail.

## Consequences

Contributors read /docs before architecture/product edits. Excluded features receive no implementation scaffolding. A reviewed baseline commit precedes implementation. Git history must contain no secrets, and the application must not depend on a remote Git provider. Select and include an open-source licence before the first software release.
