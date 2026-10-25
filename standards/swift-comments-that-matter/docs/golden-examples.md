# Golden Examples

Use these as quality anchors. Domain constraints and named evidence artifacts
are illustrative; verify them in the target project before adopting the wording.

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
- "Invariant: each file key owns one reusable task. Completion of a cancelled request must not remove its replacement, or later callers can start another duplicate request."

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
- "Cancellation: shield only the swap-through-commit/rollback region. Preparation stays cancellable; exiting after the swap but before recovery finishes can leave neither version recoverable."

## Golden 6 - SwiftUI Lazy Lifetime

Bad:
- "Stores row state."

Good:
- "Lifetime: row-local state is safe only for visual affordances that may reset after eventual eviction."

Best:
- "Lifetime: `LazyVStack` may retain an off-screen row for several updates and later discard its local state. Persist selection and in-flight work by stable item ID; never depend on either immediate eviction or permanent retention."

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

## Golden 9 - Compiler Contract Over Prose

Bad:
- "Not thread-safe."

Good:
- "Isolation: writes stay on the main actor because SwiftUI observes this state."

Best:
- "Isolation: keep writes on the main actor; SwiftUI reads this state during body evaluation and expects UI mutations on that executor. A prose warning is weaker than the `@MainActor` boundary."

## Golden 10 - Ownership And Lifetime

Bad:
- "Uses the connection handle."

Good:
- "Ownership: the upload session owns the handle until the stream closes."

Best:
- "Ownership: treat the handle as consumed once streaming starts. Lifetime: it remains valid only until server close or task cancellation, so retry paths must request a fresh handle."

## Golden 11 - Compatibility Removal Condition

Bad:
- "Temporary workaround."

Good:
- "Compatibility: keep manual invalidation while the legacy Observation fallback is enabled."

Best:
- "Compatibility: manual invalidation exists only for the legacy Observation fallback. Remove it with the fallback flag; deleting it earlier leaves UIKit/AppKit adapters with stale tracked reads."

## Golden 12 - Throwing Task Result Ownership

Bad:
- "Starts the upload in a task."

Good:
- "Ownership: the caller retains and awaits the returned upload task."

Best:
- "Ownership: transfer the returned task to the upload supervisor, which owns cancellation and must observe its throwing result. Dropping the handle leaves retry state unchanged after a failed upload."

## Golden 13 - Lazy Prefetch And Appearance

Bad:
- "Loads the row once when it appears."

Good:
- "Constraint: treat appearance as repeatable and make page requests idempotent."

Best:
- "Constraint: lazy prefetch can evaluate this row before display, and `onAppear` can run again after reentry. Keep mandatory setup outside the callback and coalesce page requests by stable page ID."

## Golden 14 - Scoped Diagnostic Exception

Bad:
- "Ignore this warning."

Good:
- "Compatibility: the scoped diagnostic exception exists for the legacy selector bridge."

Best:
- "Compatibility: keep the immediate justification in `@diagnose(reason:)` and remove the exception with the legacy selector bridge. Do not widen it beyond this adapter, where it could hide unrelated diagnostics."

## Golden 15 - No Internal Comment Needed

Redundant:

```swift
// MainActor ensures main-actor isolation.
@MainActor
final class AccountSettingsStore {}
```

Best: remove the comment. The attribute already expresses isolation; no hidden
reason or constraint has been supplied. Keep public API documentation separately
if this type is exposed to consumers.

## Golden 16 - Deliberate Compiler Contract

Redundant:
- "This annotation makes the type Sendable."

Useful when confirmed by callers:
- "Keep this type Sendable: the export coordinator transfers it to a worker actor; removing the conformance would change that supported use."

The conformance enforces the boundary. The comment preserves why it is deliberate.

## Golden 17 - Evidence Not Available

Existing claim:
- "Keep this fallback until provider P supports resumable uploads."

Review outcome:
- `needs-evidence`: the provider contract is not available in this review. Preserve the text and identify the provider documentation or integration owner needed to confirm it.

Do not invent a provider version or delete the restriction solely because the
local implementation cannot prove it.

## Anti-Golden Examples

- "This function does X..." style intros with no risk context.
- Long comments that describe each line of straightforward control flow.
- TODO/workaround/performance comments with no owner, evidence, or removal condition.
