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

## Golden 4 - Pricing Rounding Contract

Bad:
- "Calculates total and rounds it."

Good:
- "Rounds once at currency scale after combining subtotal, tax, and discount."

Best:
- "Invariant: persisted order total must equal captured amount exactly to the cent. Re-rounding intermediate components can introduce 1-cent drift and fail reconciliation."

## Golden 5 - Cancellation Point Of No Return

Bad:
- "Uses a cancellation shield."

Good:
- "Cancellation: once replacement starts, cleanup must complete before returning."

Best:
- "Cancellation: after the temporary file is swapped into place, cancellation is shielded until commit or rollback finishes. Exiting between those steps can leave neither version recoverable."

## Golden 6 - SwiftUI Lazy Lifetime

Bad:
- "Stores row state."

Good:
- "Lifetime: row-local state is safe only for visual affordances that may reset after scrolling away."

Best:
- "Lifetime: `LazyVStack` may discard off-screen row state while the item remains in the domain model. Persist selection and in-flight work by stable item ID, not in the row view."

## Golden 7 - Generated Source Of Truth

Bad:
- "Generated client for orders."

Good:
- "Generated: contract lives in `orders.proto`; regenerate the client after schema changes."

Best:
- "Generated: field numbers in `orders.proto` are the compatibility contract and must not be reused. Do not patch this generated client manually; regenerate it from the schema."

## Golden 8 - Performance Evidence

Bad:
- "Optimized for performance."

Good:
- "Performance: keep decoding off the main actor for large search fixtures."

Best:
- "Performance: keep 10k-item decoding off the main actor; `SearchResults.trace` shows it otherwise exceeds the 100 ms interaction budget."

## Anti-Golden Examples

- "This function does X..." style intros with no risk context.
- Long comments that describe each line of straightforward control flow.
- TODO/workaround/performance comments with no owner, evidence, or removal condition.
