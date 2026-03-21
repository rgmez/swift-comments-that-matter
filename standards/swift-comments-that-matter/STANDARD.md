# Swift Comments That Matter - Standard

## Scope

Canonical, assistant-agnostic guidance for writing high-value comments in Swift codebases (iOS, macOS, watchOS, tvOS, visionOS).

## Goal

Document only what protects safe changes:
- why code exists
- what must not break
- assumptions, constraints, and side effects

## Core Principle

If text explains what code does, improve the code.
If text explains intent, risk, or guarantees, write the comment.

## Refactor-First Rule

Before adding comments:
- improve naming
- extract smaller functions
- simplify control flow

If readability can be solved by refactor, do that first.

## Decision Rules

Before writing any comment:
1. Can naming or structure remove the need for it?
2. Is hidden behavior present?
3. Are there constraints, assumptions, invariants, or risks?
4. Could this API or flow be misused?

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
- `Side Effects:`
  - `Side Effects: emits finance analytics events consumed by reconciliation jobs.`
- `Concurrency:`
  - `Concurrency: stale task completions must not overwrite newer UI state.`

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
- background task scheduling limitations
- analytics side effects
- public API contracts in frameworks

## DocC Boundary

Use inline `///` comments for:
- contracts
- invariants
- assumptions
- side effects

Use DocC articles for:
- architecture
- system flows
- domain concepts
- cross-module behavior

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

## Examples

- `standards/swift-comments-that-matter/examples/bad-comments.swift`
- `standards/swift-comments-that-matter/examples/better-comments.swift`
- `standards/swift-comments-that-matter/examples/concurrency.swift`
- `standards/swift-comments-that-matter/examples/invariants.swift`
- `standards/swift-comments-that-matter/examples/api-contracts.swift`
- `standards/swift-comments-that-matter/examples/pricing-rounding.swift`
