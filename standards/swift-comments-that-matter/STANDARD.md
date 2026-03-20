# Swift Comments That Matter - Standard

## Goal

Define a reusable, assistant-agnostic standard for high-value Swift comments across iOS, macOS, watchOS, tvOS, and visionOS codebases.

The standard prioritizes:
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
4. Could this API/flow be misused?

If all answers are "no", do not comment.

## Required Comment Signals

Use comments for:
- intent
- invariants
- constraints
- side effects
- concurrency assumptions

## Forbidden Patterns

Avoid:
- "This function does..."
- "This method is responsible for..."
- implementation narration
- generic comments without risk context
- tutorial-style toy examples

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

## Tone

- human
- direct
- engineer-to-engineer
- no buzzwords
- no marketing voice

## Detailed References

- `skills/swift-comments-that-matter/docs/context.md`
- `skills/swift-comments-that-matter/docs/principles.md`
- `skills/swift-comments-that-matter/docs/decision-rules.md`
- `skills/swift-comments-that-matter/docs/checklist.md`
- `skills/swift-comments-that-matter/docs/example-constraints.md`
- `skills/swift-comments-that-matter/docs/golden-examples.md`
- `skills/swift-comments-that-matter/docs/docc-guidance.md`

## Examples

- `skills/swift-comments-that-matter/examples/bad-comments.swift`
- `skills/swift-comments-that-matter/examples/better-comments.swift`
- `skills/swift-comments-that-matter/examples/concurrency.swift`
- `skills/swift-comments-that-matter/examples/invariants.swift`
- `skills/swift-comments-that-matter/examples/api-contracts.swift`
