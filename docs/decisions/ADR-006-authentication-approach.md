# ADR-006: Better Auth and explicit authorisation

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Credentials, recovery and sessions are security-sensitive. The canonical specification prohibits hand-rolled authentication and requires hosted administrator MFA.

## Decision

Use Better Auth, its Prisma adapter and supported two-factor plugin. Store library-managed identity, accounts, sessions, verification and MFA records in the control database; store only operational tenant memberships/roles there in addition. Generate library schema from the installed version; do not invent its internal schema. Tenant DBs store actor IDs/display references, never passwords or tokens.

Email/password with verified email and transactional invitation/recovery email. Registration is closed except operator provisioning and organisation invitations. Production Owner/Administrator requires completed TOTP enrolment and a verified second-factor session; enforce server-side even if UI is bypassed. Self-hosting supports the same controls. Synthetic v0.01 exercises actual authentication/roles and MFA using local mail capture; no production bypass switches.

CRM authorisation is explicit server policy, independent of Better Auth's identity proof. Re-check active membership on each request; deactivation/role changes revoke affected sessions. Sensitive administrative actions require recent reauthentication. Secure cookies/HTTPS in production, expiry, rate limits, CSRF/origin protection, safe recovery and auditable events are mandatory.

## Rationale

A mature library handles authentication mechanics; application policy handles tenant and business permissions. Central identity makes login before tenant routing straightforward.

## Alternatives considered

Custom auth: prohibited. Mandatory external identity SaaS: breaks portable self-hosting. Mature alternatives remain possible only through a superseding ADR documenting compatibility/security evidence.

## Consequences

Version-specific behaviour must be tested, especially MFA/session state, recovery and adapter schema. Do not assume library defaults satisfy the baseline. No public signup, authentication impersonation or URL-driven tenant membership. Email delivery is transactional infrastructure, not marketing.

Sources checked 13 October 2026: [Better Auth installation](https://better-auth.com/docs/installation), [2FA](https://better-auth.com/docs/plugins/2fa), [Prisma integration](https://www.prisma.io/docs/guides/authentication/better-auth/nextjs).
