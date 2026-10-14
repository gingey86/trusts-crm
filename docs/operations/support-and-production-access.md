# Support and production access

Dependencies: security-baseline, tenancy and privacy. Hosted administration does not imply routine access to customer CRM contents.

## Normal operation

Use redacted health/version/provisioning/backup status, disk usage and operational tenant IDs. Help customers reproduce issues with synthetic examples and their own UI. No global CRM superuser screen, broad impersonation or control-database shadow CRM. Never ask for full live exports just for convenience; they contain customer data and require exceptional handling.

## Exceptional access procedure

1. Record ticket/reason, affected tenant, required scope, named operator and expected duration. Obtain customer-authorised instruction when applicable; an emergency containment action records its basis and informs the customer promptly.
2. Prefer metadata/read-only access to the single tenant. Use an individual key/account through a private administrative network, temporary narrowly scoped DB/storage credentials or a documented time-limited elevation. No shared generic operator passwords.
3. Record start/end, commands/actions and affected objects without logging sensitive contents/secrets. Put evidence in a restricted operational log, not the public repository. Cross-reference the tenant audit where appropriate.
4. Revoke temporary credentials/access at expiry, verify revocation, remove temporary artefacts and record result. A standing host administrator still has technical capability; policy/logging constrain it rather than pretending it does not exist.

Routine coding agents have no autonomous production-root access. Deployments run reviewed artefacts with documented operator actions. No experiments or unrelated services on the CRM VPS. Code/wikis contain procedures, never operational passwords or private customer incident records.

## Offboarding and monitoring

Remove operator SSH/VPN/backup access, rotate affected credentials and verify outstanding temporary access is closed. Record unique operator identities. Alert on privileged access, unexplained routing/role changes, backup failure and repeated authentication failures using inexpensive self-hosted tools/logs. Rotate redacted infrastructure/security telemetry under documented deployment policy, separately from canonical business audit. Review access before pilot and regularly under that policy; quarterly review is an initial recommendation, not fixed product architecture. Significant customer/business access events retain appropriate attribution under organisation-controlled CRM history.

## Acceptance

Demonstrate an operator supporting version/health checks without CRM browsing, obtaining narrow tenant access for a synthetic incident, recording a reason and losing access on revocation/expiry. Organisation administrators remain unable to obtain platform access or other tenants' files/backups.
