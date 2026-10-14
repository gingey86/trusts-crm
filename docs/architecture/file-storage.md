# File storage

Dependencies: ADR-007, tenancy and data-model. Local filesystem first, replaceable Storage interface; no host paths in business code.

## Contract

Storage.put/open/stat/remove operate on application-generated opaque keys and streams. Config selects backend and root. Local Docker volume mounts at a documented internal container path; host locations are Docker-managed or explicitly configured. Future S3-compatible adapter accepts endpoint, bucket and credentials without altering record workflows. Do not pretend S3 is supported before an adapter is implemented.

Initial key layout: tenants/{tenant UUID}/objects/{random UUID}; private staging/exports use tenants/{tenant UUID}/staging-or-exports/{random UUID}. The precise layout may change behind the adapter; explicit tenant ownership and opaque keys are architectural constraints. Display filenames never become paths. Resolve canonical paths under the configured root, reject traversal/symlinks and never trust client keys. Root is outside public web assets and readable only by the app/operator identities.

## Upload lifecycle

Authenticate/authorise parent → verify extension and streamed byte limit → create uploading metadata → stream into private staging → compute SHA-256 and inspect actual MIME/signature → malware scan when configured → atomic move → ready metadata. Failed/interrupted entries never download; reconciler removes expired staging/orphans after checks. DB failure after move is reported/reconciled, not hidden. No filesystem operation is falsely described as part of a PostgreSQL transaction.

Initial configurable maximum is 20 MiB per file. Initial allowlist: PDF, DOCX, XLSX, CSV, TXT, PNG, JPEG. Reject executables, HTML, SVG and arbitrary archives; inspect zipped Office signatures safely without unbounded decompression. Permit replaceable malware-scanner adapters or deployment-level inspection where appropriate. Document the production deployment's chosen controls after evaluating risks and resources; no particular scanner or daemon is a condition of self-hosting. When scanning is configured, failed/unavailable inspection keeps the upload unavailable. Synthetic tests may use a declared test scanner. No external file-processing service is required.

## Access and links

GET /internal/documents/{id}/download resolves only current tenant metadata and authorised parent. Return safe Content-Disposition attachment, nosniff and private/no-store caching. Permission denial never reveals a filename. Ordinary Read-only users can download authorised attachments; bulk export remains admin-only. Same document can have typed links to Application/Grant while retaining one object. At least one accessible parent is required.

Archive retains bytes and linked history. Canonical documents have no age-based expiry; permanent removal belongs to the organisation-authorised erasure procedure. Generated export packages and abandoned upload staging are private, tenant/actor owned technical artefacts with configurable cleanup policy. Cleanup verifies lifecycle/ownership and never removes retained source attachments or CRM records; stale package URLs fail after cleanup. Download tokens, if ever added, must be scoped and time-limited under security policy, not public capability URLs by default.

## Persistence, backup and exit

Recreating app containers preserves the attachment volume. Backup includes bytes, metadata/checksums and pending-state handling from a consistent cut. Restore into an isolated destination validates every ready object. Complete customer export includes documents, stable manifest and checksums; importing into self-hosted local storage remaps backend keys without changing domain links. Do not include one tenant's staging, exports or backup paths in another's archive.
