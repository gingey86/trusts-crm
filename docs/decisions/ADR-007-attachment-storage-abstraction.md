# ADR-007: Private replaceable attachment storage

Status: Accepted. Date: 13 October 2026. Supersedes: none. Superseded by: none.

## Context

Documents must be private, portable and recoverable. PostgreSQL rows should not contain file bytes; storage tied to a particular development host would prevent self-hosting.

## Decision

Business services call a Storage interface: put(stream, key, metadata), open(key), remove(key), stat(key). Local filesystem adapter initially; configurable root mounted as persistent Docker storage. Opaque server-generated tenant-prefixed keys, never user-supplied paths. DB Document stores metadata, checksum, storage key/backend and lifecycle state. Typed parent links stay in the tenant DB. Later S3-compatible support implements the interface without changing business workflows.

Authenticated download handlers resolve tenant, parent and permissions before opening bytes. No public directory, predictable public URL or direct static serving. Application-derived metadata is authoritative; validate filename, byte count, MIME/signature and permitted extensions. Upload staging/quarantine is private. Restrict active content and enforce configured limits. Permit malware inspection through a replaceable scanner adapter or deployment-level control. The production deployment documents its chosen upload-security controls; no particular scanner or daemon is required by the product. Where scanning is configured, failed or unavailable inspection prevents that upload from becoming downloadable.

## Rationale

One abstraction separates portable business logic from storage mechanics and permits per-tenant backup/export.

## Alternatives considered

Byte columns: rejected. Hard-coded shared host directory: rejected. Public object URLs: rejected. Mandatory cloud bucket: undermines simple self-hosting.

## Consequences

DB and filesystem are not a shared transaction. Initial implementation uses staged/uploading/ready/failed states, atomic local rename and reconciliation for interrupted uploads/orphans; equivalent mechanisms must preserve the same consistency guarantees. Archive does not remove bytes. Canonical attachments have no age-based expiry; erasure is an explicit organisation-authorised, audited operational action. Temporary cleanup must distinguish abandoned staging from retained documents. Backups capture matching DB metadata and files; restoration verifies checksums and missing objects. App-container replacement never removes persistent storage.
