# Golden Examples

Use these as quality anchors.

## Golden 1 - Token Refresh Deduplication

Bad:
- "Refreshes token when needed."

Good:
- "Coalesces concurrent refresh requests to avoid issuing multiple refresh calls for the same expired token window."

Best:
- "Concurrency: Only one refresh task may exist per account at a time. Parallel refresh calls can invalidate each other's token chain and trigger forced logout on next API call."

## Golden 2 - Download Dedup Invariant

Bad:
- "Starts a download if needed."

Good:
- "Keeps one active task per file key; duplicate requests subscribe to the same task."

Best:
- "Invariant: `activeTasks[fileKey]` owns the single network task for that file. Breaking this invariant causes duplicate writes and races when finalizing checksum validation."

## Golden 3 - Payment Capture Constraint

Bad:
- "Captures payment."

Good:
- "Captures only after fraud check passes and authorization remains valid."

Best:
- "Constraint: capture must occur within provider authorization window. Retrying capture outside that window can settle and immediately refund, creating reconciliation drift."

## Anti-Golden Examples

- "This function does X..." style intros with no risk context.
- Long comments that describe each line of straightforward control flow.
