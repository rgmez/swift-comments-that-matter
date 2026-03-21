---
name: swift-comments-that-matter
description: Write high-value Swift comments that explain intent, invariants, constraints, side effects, and concurrency risks. Use when reviewing or authoring comments in iOS/macOS/watchOS/tvOS/visionOS codebases, especially to replace low-signal "what it does" comments with concise "why and what must not break" documentation.
---

# Swift Comments That Matter

Compatibility note: this `SKILL.md` is the Cursor adapter entrypoint.
Canonical standard lives at `standards/swift-comments-that-matter/STANDARD.md`.

## Purpose

Use this skill to produce comments that help future maintainers make safe changes.

Default rule:
- If text explains what the code does, improve the code.
- If text explains why code exists or what must not break, write the comment.

## When To Use This Skill

Apply this skill when:
- reviewing `///` comments in Swift code
- refactoring low-signal comments
- documenting API contracts and invariants
- clarifying hidden behavior, side effects, or concurrency risks

## Start Here

1. Apply the decision flow in this file.
2. Use the rewrite pattern: no comment -> bad -> good -> best.
3. Follow AI guardrails and voice calibration.

## Read When Needed

- Tone and context: [docs/context.md](docs/context.md)
- Decision details: [docs/decision-rules.md](docs/decision-rules.md)
- Quality checks: [docs/checklist.md](docs/checklist.md)
- Example constraints: [docs/example-constraints.md](docs/example-constraints.md)
- DocC boundaries: [docs/docc-guidance.md](docs/docc-guidance.md)
- Golden references: [docs/golden-examples.md](docs/golden-examples.md)

## Quick Routing

- Quick review path: `docs/checklist.md`
- Rewrite path: `docs/decision-rules.md` + `docs/golden-examples.md`
- DocC boundary path: `docs/docc-guidance.md`

## Core Principle

If the text explains what the code does -> improve the code.
If the text explains why it exists or what must not break -> write the comment.

## Refactor-First Rule

Before writing a comment, first consider:
- renaming variables/functions/types
- extracting smaller functions
- simplifying control flow

If readability can be improved, refactor first.

## Decision Flow

Before writing a comment, ask:
1. Can naming or structure remove the need for the comment?
2. Is there hidden behavior not obvious from code?
3. Are there constraints, assumptions, invariants, or risks?
4. Could another developer misuse this API or flow?

If all answers are "no", do not comment.

## Preferred Comment Sections

Use only when needed:
- `Important:`
- `Why:`
- `Assumption:`
- `Constraint:`
- `Invariant:`
- `Side Effects:`
- `Concurrency:`

## When Not To Comment

Do not comment when:
- the sentence only repeats implementation
- the name can carry the meaning after small refactor
- the statement is generic and risk-free
- the comment adds length but no new decision context

## Example Pattern Rule

Each scenario must include:
1. No comment version (clean but incomplete)
2. Bad comment version (common anti-pattern)
3. Good comment version (useful)
4. Best version (intent + constraints + reasoning)

## Required Scenarios

The skill must cover:
- token refresh with concurrency issues
- download manager deduplication invariant
- cache eviction assumptions
- payment logic business constraints
- pricing and currency rounding constraints
- SwiftUI async lifecycle edge cases
- background task scheduling limitations
- analytics side effects
- public API contracts in frameworks

## Anti-Patterns

Avoid:
- "This function does..."
- "This method is responsible for..."
- "This class..."
- line-by-line narration
- tutorial-style toy examples
- long comments with no constraints or risk

## AI Guardrails

When generating comments:
- NEVER start with:
  - "This function..."
  - "This method..."
  - "This class..."
- Prefer direct statements, constraints, risks, and reasoning.
- Keep comments concise. Remove filler words.

## Voice Calibration

Write like an experienced iOS engineer speaking to another engineer:
- human and direct
- no buzzwords
- no marketing tone
- no over-polished generic phrasing

## DocC Boundary Rule

Use inline `///` comments for:
- contracts
- invariants
- assumptions
- side effects

Use DocC articles for:
- architecture explanations
- system flows
- domain concepts
- cross-module behavior

## Compatibility Note

Examples assume modern Swift codebases (Swift 5.9+), Swift Concurrency usage, and current SwiftUI lifecycle patterns.

## Examples

- [examples/bad-comments.swift](examples/bad-comments.swift)
- [examples/better-comments.swift](examples/better-comments.swift)
- [examples/concurrency.swift](examples/concurrency.swift)
- [examples/invariants.swift](examples/invariants.swift)
- [examples/api-contracts.swift](examples/api-contracts.swift)
- [examples/pricing-rounding.swift](examples/pricing-rounding.swift)

## Additional Resources

- [docs/principles.md](docs/principles.md)
- [docs/context.md](docs/context.md)
- [docs/decision-rules.md](docs/decision-rules.md)
- [docs/checklist.md](docs/checklist.md)
- [docs/example-constraints.md](docs/example-constraints.md)
- [docs/golden-examples.md](docs/golden-examples.md)
- [docs/docc-guidance.md](docs/docc-guidance.md)
