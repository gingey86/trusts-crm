# Upgrades and release identity

Dependencies: deployment, self-hosting, backups-and-restore. Commands are implementation contracts until scripts/images exist.

## Version contract

Every release identifies application version, Git commit, Node/dependency lock, image digest, control migration version and tenant migration target. An authenticated diagnostics page/operator command displays these without secrets. Commit migrations; never edit an already-applied migration. Future tags/images use versioned immutable releases, not an unrecorded latest-only deployment. Release automation is deferred, reproducible version identity is not.

## Supported flow

The commands below describe the initial operator-container implementation. Release tooling may orchestrate them, but must preserve explicit migrations, privilege separation, version matching, persistent data and tested recovery. Container target names and locking mechanics are implementation choices, not immutable architecture. Backup retention follows deployment recovery policy and never governs source CRM/business-audit retention.

1. Read release notes/compatibility and disk requirements. Verify currently running versions and all tenant schema states. Test the release using synthetic staging.
2. Take a consistent encrypted off-host recovery set covering control, all tenant DBs, attachments, credential/configuration material. Record restore point and both current application/operator image digests. Confirm the set is restorable.
3. Schedule a maintenance window and block writes, uploads and background mutations. Fetch the release source or versioned images. For source builds, update the checkout and run `docker compose --profile tools build app operator` so both targets use the new release. For published images, set APP_IMAGE and OPERATOR_IMAGE to the matching release references, set APP_VERSION and run `docker compose --profile tools pull app operator`. Record the resolved digests of both images.
4. Run `docker compose --profile tools run --rm operator pnpm db:migrate`. It migrates control and enumerates active tenants using operator-only credentials, migration concurrency protection and per-tenant status/version. A failure returns non-zero and keeps incompatible tenants unavailable. Safe retry must not rerun destructive steps blindly.
5. Recreate the app: `docker compose up -d --no-deps app`. Keep Compose project identity and volumes. Verify health, authentication, schema compatibility, sample source-derived calendar and attachment checksums. End maintenance only after checks succeed.
6. Record release, image/commit, migrations, backup ID, operator, timings and outcomes in a private deployment log; update wiki instructions if actual mechanics changed. Public Git contains no customer/secret details.

No normal upgrade uses manual SQL surgery, reseeding or deleting volumes. PostgreSQL major upgrades are separate planned recovery/migration procedures, never an accidental image tag change. Schema migrations use reviewed expand/contract changes where possible; do not assume old application code is compatible with the new schema.

## Rollback and recovery

If failure occurs before incompatible schema change, the previous image may be restarted only after compatibility verification. If migration changed data/schema incompatibly, restore the pre-upgrade coordinated DB/files/config set into an isolated recovery destination, verify it, then switch routing. Report any lost post-backup writes; a rollback cannot pretend to retain them. Never overwrite a live multi-tenant server from one tenant backup.

## Acceptance

Demonstrate upgrading a seeded old release, preserved native values/history/files, intentional migration failure and safe retry, previous-image compatibility decision and restore fallback. Record clean-install and upgrade evidence for v0.1. Support hosted and self-hosted installs with the same schema and commands.
