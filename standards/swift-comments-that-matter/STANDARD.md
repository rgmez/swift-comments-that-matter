# Swift Comments That Matter - Standard

## Scope

Canonical, tool-agnostic guidance for writing high-value comments in Swift codebases (iOS, macOS, watchOS, tvOS, visionOS).

## Goal

Document only what protects safe changes:
- why code exists
- what must not break
- assumptions, constraints, and side effects

## Core Principle

If text explains what code does, improve the code.
If text explains intent, risk, or guarantees, write the comment.

## Contract Hierarchy

Prefer stronger sources of truth before prose:
1. encode the contract in types, isolation, ownership, availability, diagnostics, or API shape;
2. verify the contract with tests or preconditions when it is executable;
3. comment only the decision, boundary, trade-off, or failure mode still invisible;
4. move broader system context to DocC when it no longer belongs to one symbol.

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
3. Is hidden framework behavior present?
4. Does correctness depend on identity, ordering, lifetime, cancellation, isolation, ownership, or backpressure?
5. Is there a generated artifact or external source of truth?
6. Does the comment include a verifiable condition for remaining true or being removed?
7. Could this API or flow be misused without compiler/test feedback?

If all answers are "no", do not comment.

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
- `Backpressure:`
  - `Backpressure: await each outbound write to preserve server ordering.`
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

Every scenario must include:
1. no comment
2. bad comment
3. good comment
4. best comment (staff-level intent + constraints + reasoning)

## Required Scenarios

- token refresh concurrency issues
- download manager deduplication invariant
- cache eviction assumptions
- payment business constraints
- pricing and currency rounding constraints
- SwiftUI async lifecycle edge cases
- SwiftUI identity, lazy-container state lifetime, and repeatable `onAppear`
- Observation dependencies registered implicitly by framework reads
- cancellation boundaries, cleanup, rollback, and point-of-no-return behavior
- actor isolation, task ownership, and non-copyable ownership/lifetime constraints
- stream ordering, cancellation, and backpressure
- generated-code source-of-truth and regeneration boundaries
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
- do not add manual documentation to generated artifacts
- document the schema, specification, or stable wrapper that owns the contract
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
- `standards/swift-comments-that-matter/examples/invariants.swift`
- `standards/swift-comments-that-matter/examples/api-contracts.swift`
- `standards/swift-comments-that-matter/examples/pricing-rounding.swift`
- `standards/swift-comments-that-matter/examples/modern-contracts.swift`
