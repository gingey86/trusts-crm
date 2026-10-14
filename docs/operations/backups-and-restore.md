# Backups and restoration

Dependencies: tenancy/file-storage, privacy-and-data-handling, upgrades. A snapshot alone is not a backup strategy. Synthetic development backups stay synthetic; real restores use approved production-grade recovery environments, never ordinary development/testing.

## Required recovery set

Control DB; individual pg_dump custom-format tenant DBs; private attachment bytes/manifests/checksums; tenant credentials, required auth/encryption/configuration and deployment/image/schema identity. Encrypt secrets/config separately with restricted key access. Store off-host in an inexpensive independent destination using restic or equivalent open-source tooling. Keys/recovery instructions must exist independently of the failed VPS and never in Git.

Each tenant has an explicit set/prefix and manifest: opaque tenant ID, capture timestamp, app/schema versions, file checksums and dump identity. Control DB includes operational auth/session information and receives narrower operator access; customer export never includes the whole control DB. Do not mix tenants into an ambiguous dump or expose backup artefacts through the app.

## Schedule and consistency

Backup schedule, retention, recovery-point and recovery-time targets are deployment policy, not CRM record-retention rules. Establish and measure the managed policy before production; self-host administrators choose and document their own schedule and retention. Nightly backups are an initial recommendation, not a universal requirement. Retain pre-upgrade recovery points under that policy. Alert on missed/failed/undersized backups and low disk. Each recovery set must be uploaded, encrypted and verified, not just staged locally.

The initial consistency method uses a short maintenance/read-only window, stops mutations/uploads/jobs, captures control and tenant dumps with an attachment snapshot/copy from the same quiescent cut, verifies manifests, then resumes writes. A database dump paired with changing attachments is not guaranteed consistent. A different tested recovery method may replace these mechanics, with updated documentation and an ADR if it changes an architectural decision. Consistent recoverable data is the requirement.

## Restore procedure

1. Identify incident/tenant, authorised operator and target restore point. Record reason. Create isolated production-grade recovery host/DB/storage, with no user routing or outbound customer email.
2. Fetch/decrypt selected set; verify provenance, checksums, tenant identity and schema/application compatibility. Reject a mismatched tenant/destination. Restore tenant DB under restricted new credentials and files into its private prefix.
3. For whole-service recovery restore control carefully, rotate secrets/credentials as required and invalidate old sessions. For one-tenant recovery update only that tenant's routing; never restore the full control DB over live tenants.
4. Reapply organisation/record deletion tombstones before making restored data accessible. Validate relationships, native values/rates, ready document checksums, role/isolation and calendar projections. Disable old routes before switching; explain any post-backup data loss.
5. Resume deliberately, monitor and record duration/result. Remove recovery work artefacts securely within the documented retention window.

## Proof and deletion

Demonstrate restoration before the first real pilot and repeat under the documented operational schedule; quarterly drills are an initial recommendation. Test one-tenant recovery while another stays intact and complete clean-host recovery. Keep non-sensitive evidence in the wiki; private set IDs/customer details stay in restricted operations records. After authorised erasure, apply the declared backup lifecycle and retain minimal deletion markers for as long as recoverable copies could resurrect erased information. Reapply erasure before restoring access and report remaining recovery-copy expiry/removal. Longer backup schedules may be agreed; there is no product-wide maximum period.

Self-host administrators receive the same runbook and are responsible for operating independent backups on their infrastructure. Backup rotation never deletes active or archived source CRM history, attachments or business audit. Seven-year and longer CRM retention remains organisation-controlled. A container volume is persistence, not redundancy; recreating the app safely does not protect against disk loss.
