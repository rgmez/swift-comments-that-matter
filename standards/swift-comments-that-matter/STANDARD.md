# Swift Comments That Matter - Standard

## Scope

Canonical, tool-agnostic guidance for writing high-value comments in Swift codebases (iOS, macOS, watchOS, tvOS, visionOS).

## Goal

Document only what protects safe changes:
- why code exists
- what must not break
- assumptions, constraints, and side effects

## Core Principle

For implementation commentary, prefer names and structure over narration.
Preserve useful symbol documentation and the intent behind deliberate guarantees.

## Public Documentation And Internal Comments

The anti-narration rule targets internal implementation commentary. Public API
reference documentation still needs a concise summary of observable behavior,
plus parameters, return values, errors, and usage constraints when relevant.
Do not remove a useful API summary because the implementation or tests express
its behavior; consumers may only see the declaration and rendered documentation.
Use `///` for symbol documentation and `//` for implementation-local rationale.
See [DocC guidance](docs/docc-guidance.md) for placement and syntax.

## Evidence And Scope

Verify claims against implementation, callers, tests, or maintained external
contracts before rewriting them as facts. Do not invent business reasons,
analytics events, issue IDs, measurements, or guarantees. When evidence is
missing, classify the claim as `needs-evidence`, preserve it provisionally, and
state what could resolve the gap instead of inventing proof or deleting context.

Refactor-first is a decision rule, not permission to expand the task. In a
comment-only review, propose code changes separately; apply them when they fit
the authorized scope. Flag correctness bugs rather than documenting them as
intentional behavior.

## Contract Hierarchy

Prefer stronger sources of truth before prose:
1. encode the contract in types, isolation, ownership, availability, diagnostics, or API shape;
2. verify the contract with tests or preconditions when it is executable;
3. comment only the decision, boundary, trade-off, or failure mode still invisible;
4. move broader system context to DocC when it no longer belongs to one symbol.

This hierarchy does not remove API documentation or the rationale for a deliberate
annotation. Keep the reason an enforced contract must survive later edits.
Read [concurrency contracts](docs/concurrency-contracts.md) for isolation settings,
task ownership, and cleanup under cancellation.

## Compiler And Framework Boundaries

- Resolve ignored throwing-task diagnostics by catching the error, awaiting the
  task, or transferring its handle to an explicit owner. A comment does not own
  a task outcome.
- Put the immediate justification for a local diagnostic exception in
  `@diagnose(reason:)`. Add prose only when a broader domain consequence or
  verifiable removal condition remains invisible.
- Keep cancellation shields limited to required cleanup or commit/rollback work.
  Async `defer` alone does not stop cleanup from observing cancellation. Document
  the consistency boundary; a shield does not make writes atomic.
- Check module isolation and feature flags before claiming `async` or `nonisolated`
  moves execution off an actor. Preserve deliberate annotations and their rationale.
- Do not promise exact lazy-container eviction timing. Off-screen views can be
  retained temporarily and later discarded with their local state.
- Treat `onAppear` as a repeatable appearance signal, not guaranteed one-time
  initialization. Prefetch can evaluate a view body even when that appearance
  callback never runs.

## Refactor-First Rule

Before adding comments:
- improve naming
- extract smaller functions
- simplify control flow

If readability can be solved by refactor, do that first.

## Decision Rules

Before writing any comment:
1. Can naming or structure remove the need for it?
2. Can types, actor isolation, ownership, availability, diagnostics, tests, or preconditions express the contract?
3. Is hidden framework behavior such as prefetch, reentry, or Observation tracking present?
4. Does correctness depend on identity, ordering, task-result ownership, lifetime, cancellation, isolation, ownership, or backpressure?
5. Is there a generated artifact or external source of truth?
6. Does the comment include a verifiable condition for remaining true or being removed?
7. Could this API or flow be misused without compiler/test feedback?

Resolve questions 1–2 first. For internal comments, if no hidden context remains
in questions 3–7, omit the comment. Preserve useful public API documentation.

## When Not To Comment

Do not add comments when:
- the sentence only paraphrases implementation
- small refactors can make intent obvious
- the statement is generic and could fit any function
- there is no non-obvious risk, contract, or trade-off

## Required Comment Signals

Use comments for:
- intent
- invariants
- constraints
- side effects
- concurrency assumptions
- externally visible contracts

## Comment Sections With Examples

Use section labels only when they improve scanability. Keep each line specific.

- `Why:`
  - `Why: token refresh calls are coalesced to prevent chain invalidation.`
- `Invariant:`
  - `Invariant: only one in-flight refresh task may exist per account.`
- `Constraint:`
  - `Constraint: totals are rounded once at provider scale before capture.`
- `Assumption:`
  - `Assumption: cache policy validation happened upstream.`
- `Risk:`
  - `Risk: parallel refreshes can invalidate token chain order.`
- `Side Effects:`
  - `Side Effects: emits finance analytics events consumed by reconciliation jobs.`
- `Concurrency:`
  - `Concurrency: stale task completions must not overwrite newer UI state.`
- `Cancellation:`
  - `Cancellation: once replacement starts, cleanup must complete before returning.`
- `Isolation:`
  - `Isolation: mutations must stay on the main actor because UIKit reads this state during layout.`
- `Ownership:`
  - `Ownership: the stream writer consumes this handle and is responsible for closing it.`
- `Lifetime:`
  - `Lifetime: row state may reset when a lazy container discards an off-screen view.`
- `Observation:`
  - `Observation: keep this read inside the tracked context so mutations invalidate the adapter.`
- `Backpressure:`
  - `Backpressure: producers suspend when the bounded channel is full; do not replace it with an unbounded buffer.`
- `Performance:`
  - `Performance: keep 10k-item decoding off the main actor; trace shows it exceeds the interaction budget.`
- `Compatibility:`
  - `Compatibility: remove this fallback after dropping iOS 26 support.`
- `Generated:`
  - `Generated: contract lives in the schema; regenerate the client instead of patching this file.`

Prefer the most precise section. Use `Concurrency:` only for broad concurrency context; use `Cancellation:`, `Isolation:`, `Ownership:`, or `Backpressure:` when one of those is the actual risk.

## Forbidden Patterns

Avoid:
- "This function does..."
- "This method is responsible for..."
- implementation narration
- generic comments without risk context
- tutorial-style toy examples

## Mini Quality Rubric

Score each comment from 0 to 2 in each category:

- Signal:
  - `0` repeats code
  - `1` partially useful but generic
  - `2` explicit decision context
- Safety:
  - `0` no failure mode captured
  - `1` hints at risk
  - `2` states what breaks if changed
- Actionability:
  - `0` cannot guide future edits
  - `1` somewhat directional
  - `2` gives clear boundaries for safe refactor

Target quality: no category below `1`, and at least one category at `2`.

## Example Quality Rule

Teaching examples with hidden context use:
1. no comment
2. bad comment
3. good comment
4. best comment (staff-level intent + constraints + reasoning)

Include negative controls where no internal comment is best. Ordinary reviews
need only the recommendation and final rewrite unless four variants are requested.

## Required Scenarios

- token refresh concurrency issues
- download manager deduplication invariant
- cache eviction assumptions
- payment business constraints
- pricing and currency rounding constraints
- SwiftUI async lifecycle edge cases
- SwiftUI identity, lazy-container state retention/eviction, prefetch, and repeatable `onAppear`
- Observation dependencies registered implicitly by framework reads
- cancellation boundaries, narrowly scoped shields, cleanup, rollback, and point-of-no-return behavior
- throwing-task result ownership and unobserved error handling
- actor isolation and non-copyable ownership/lifetime constraints
- stream ordering, cancellation, and backpressure
- generated-code source-of-truth and regeneration boundaries
- local diagnostic exceptions with a removal condition
- performance constraints backed by reproducible evidence
- compatibility workarounds with explicit removal conditions
- background task scheduling limitations
- analytics side effects
- public API contracts in frameworks

## DocC Boundary

Use inline `///` comments for:
- contracts
- invariants
- assumptions
- side effects
- local compatibility or performance constraints

Use DocC articles for:
- architecture
- system flows
- domain concepts
- cross-module behavior
- version-dependent behavior spanning multiple symbols

Generated code boundary:
- do not manually patch generated artifacts
- document the schema, specification, stable wrapper, or a DocC extension for a symbol included in the documentation build
- include the regeneration command or process when it is not discoverable

## DocC Boundary Examples

Inline `///` (symbol-local contract):

```swift
/// Constraint: empty user IDs fail fast and never hit transport.
public func fetchProfile(userID: String) async throws -> Data
```

DocC article (cross-symbol behavior):

```markdown
# Authentication Pipeline
Describes refresh token coalescing, retry budget policy, and account-scoped isolation across modules.
```

## Tone

- human
- direct
- engineer-to-engineer
- no buzzwords
- no marketing voice

## Detailed References

- `standards/swift-comments-that-matter/docs/concurrency-contracts.md`
- `standards/swift-comments-that-matter/docs/context.md`
- `standards/swift-comments-that-matter/docs/principles.md`
- `standards/swift-comments-that-matter/docs/decision-rules.md`
- `standards/swift-comments-that-matter/docs/checklist.md`
- `standards/swift-comments-that-matter/docs/example-constraints.md`
- `standards/swift-comments-that-matter/docs/golden-examples.md`
- `standards/swift-comments-that-matter/docs/docc-guidance.md`
- `standards/swift-comments-that-matter/docs/review-red-flags.md`

## Examples

- `standards/swift-comments-that-matter/examples/bad-comments.swift`
- `standards/swift-comments-that-matter/examples/better-comments.swift`
- `standards/swift-comments-that-matter/examples/concurrency.swift`
- `standards/swift-comments-that-matter/examples/async-cleanup.swift`
- `standards/swift-comments-that-matter/examples/invariants.swift`
- `standards/swift-comments-that-matter/examples/api-contracts.swift`
- `standards/swift-comments-that-matter/examples/pricing-rounding.swift`
- `standards/swift-comments-that-matter/examples/modern-contracts.swift`
