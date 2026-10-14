# Fundraising workflows

Dependencies: product-spec and scope-and-exclusions. All mutations require server-side tenant and role checks, input validation and audit where significant. Multi-record lifecycle actions are transactional and safe to retry.

## Create and enrich

Create a Funder with name and default Prospect status; current user is relationship owner. Optional details can follow: website, type, geography/themes, typical grant range/currency, restrictions, application method, invitation-only flag, reapplication-until date and notes. A Contact requires name and funder. Moving a contact preserves the old association rather than rewriting Interaction history.

Create an Opportunity with title and funder. Default Research, current owner, organisation reporting currency and current financial year. Amount and probability may be unknown (null); null never means zero. Purpose, restriction classification, priority, deadline, planned submission, expected decision, contacts and notes can be added later. Probability is a decimal fraction from 0 to 1; no automatic stage probability.

Eligibility, invitation-only status and reapplication restrictions appear as warnings on the Funder and Opportunity. They do not prevent creating or researching an Opportunity. At submission, an authorised Fundraiser must acknowledge any applicable restriction and record the invitation or exception that permits the application. Record this acknowledgement in the audit trail.

## Pipeline and application

Research → Qualified → Cultivation → Preparing are editable working stages, with backwards movement allowed. Pre-submission abandonment sets Withdrawn with reason and retains the record. Submitting requires date-only submission date, requested decimal amount/currency and a linked funder. The action creates a submitted Application and sets Opportunity Submitted in one transaction; copied values remain a submission snapshot, distinct from later Opportunity estimates.

At most one pending Application per Opportunity. Later submissions after a rejected/withdrawn outcome use a new Opportunity linked to the same Funder; amended documents use Application version/attachments rather than another live application. Never overwrite a rejected submission.

Submitted → Decision due may be selected explicitly and is not automatically triggered by a clock. Passing the expected decision date creates an attention flag. Submission transfers the expected decision date to the Application and clears the writable Opportunity field. The Opportunity then displays the Application date as a projection, producing one calendar event.

Application decisions: Pending, Successful, Rejected, Withdrawn. Recording a decision requires actual decision date and optional feedback; Successful also requires awarded amount/currency. Rejected sets Lost; Withdrawn sets Withdrawn; Successful sets Won. A successful Application has an explicit Create grant action. It carries forward funder, purpose, owner, requested/awarded native values, contacts and linked document access without copying file bytes. Exactly one Grant per Application; repeated clicks return the same Grant.

Terminal-stage dragging is unavailable. Incorrect outcomes may be corrected by Owner/Administrator with a reason. A linked Grant prevents reverting success until an explicit audited correction reconciles it; never erase the historical award silently.

## Grant and obligations

A new Grant defaults Awaiting agreement. Set funding dates, restriction classification, agreement and reporting requirements, then mark Active. Add structured Obligations with grant, title, type, due date and responsible user. Types: Interim report, Final report, Financial report, Payment request, Monitoring return, Renewal/reapplication, Other. Basic payment milestones are Payment request Obligations with optional native amount/currency and notes, not a payment engine.

Obligation workflow: Upcoming → In progress → Submitted → Complete; direct completion is allowed for non-report requirements. Submission/completion records date and actor. Not required needs a reason. Overdue is derived when due date is before organisation-local today and status is not Submitted, Complete or Not required. Submitted still appears in history and awaiting-confirmation lists.

Grant Complete requires every Obligation to be Complete or Not required. Closed early requires reason and explicit disposition of outstanding Obligations. No silent cascade. An administrator can reopen with an audit reason.

## Tasks, next actions and interactions

Tasks require a title and owner; date and record link are optional. A Funder or Opportunity can designate one linked open Task as its next action. The same Task appears in each view. Completion, cancellation or archival clears the designation; no replacement is generated automatically. The calendar renders a designated Task once with next-action styling.

Interaction requires funder, date, type and summary; contacts and Opportunity/Grant links optional and must belong to that funder. Last meaningful interaction is derived from non-archived Interactions. Optional follow-up creates a linked Task in the same transaction.

## FX, archive and portability

Owner/Administrator chooses the financial year in Settings and edits its source-to-reporting rates, for example “FY2027: USD 1 = GBP 0.77”. Saving an existing-year change explains that the year's planning figures will recalculate and creates a business audit event. No revision-management screen or separate impact-preview flow is required. Conversion uses the record's planning year and that year's configured rate. Export metadata preserves the exact rate basis internally. Missing rates show native figures and an excluded-record warning.

Archiving removes ordinary records from active work lists without deleting links, applications or grants. Archiving a parent with active children requires explicit acknowledgement; active children remain independently visible and show the archived-parent badge. Unarchive restores visibility. Historical views, search include-archived mode and exports preserve links.

Record age never triggers deletion, expiry or archival. Historical tasks, next-action designations and business audit remain available under organisation-controlled retention, including at least a seven-year audit horizon and longer where required. Clearing a current next-action designation changes current state; its significant history remains in audit. Deliberate erasure follows the authorised privacy procedure, separate from temporary-file cleanup.

Import: select entity → upload CSV → map → preview every validation error → confirm valid file → atomic commit. No partial rows, silent skips or implicit merges. Export is administrator-only, audited and includes archived records, stable IDs, relationship IDs, native values, conversions with basis and document manifest. Private attachment downloads require the same authorisation as viewing their parent.
