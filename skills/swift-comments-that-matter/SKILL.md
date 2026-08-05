---
name: swift-comments-that-matter
description: Write high-value Swift comments that explain intent, invariants, constraints, side effects, Swift Concurrency risks, SwiftUI lifecycle behavior, generated-code boundaries, and contracts not fully expressed by types or tests. Use when reviewing or authoring comments in iOS/macOS/watchOS/tvOS/visionOS codebases, especially to replace low-signal "what it does" comments with concise "why, what must not break, and when this guidance can be removed" documentation.
---

# Swift Comments That Matter

Compatibility note: this `SKILL.md` is the portable skill entrypoint for runtimes that load skill packages directly, including Cursor-compatible installs.
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
3. Follow writing guardrails and voice calibration.

## Read When Needed

- Tone and context: [docs/context.md](docs/context.md)
- Decision details: [docs/decision-rules.md](docs/decision-rules.md)
- Quality checks: [docs/checklist.md](docs/checklist.md)
- Example constraints: [docs/example-constraints.md](docs/example-constraints.md)
- DocC boundaries: [docs/docc-guidance.md](docs/docc-guidance.md)
- Golden references: [docs/golden-examples.md](docs/golden-examples.md)
- Review red flags: [docs/review-red-flags.md](docs/review-red-flags.md)

## Quick Routing

- Quick review path: `docs/checklist.md`
- Rewrite path: `docs/decision-rules.md` + `docs/golden-examples.md`
- Review anti-pattern path: `docs/review-red-flags.md`
- DocC boundary path: `docs/docc-guidance.md`

## Core Principle

If the text explains what the code does -> improve the code.
If the text explains why it exists or what must not break -> write the comment.

## Contract Hierarchy

Prefer stronger sources of truth before prose:
1. encode the contract in types, isolation, ownership, availability, diagnostics, or API shape;
2. verify the contract with tests or preconditions when it is executable;
3. comment only the decision, boundary, trade-off, or failure mode still invisible;
4. move broader system context to DocC when it no longer belongs to one symbol.

## Refactor-First Rule

Before writing a comment, first consider:
- renaming variables/functions/types
- extracting smaller functions
- simplifying control flow

If readability can be improved, refactor first.

## Decision Flow

Before writing a comment, ask:
1. Can naming or structure remove the need for the comment?
2. Can types, actor isolation, ownership, availability, diagnostics, tests, or preconditions express the contract?
3. Is there hidden framework behavior not obvious from code?
4. Does correctness depend on identity, ordering, lifetime, cancellation, isolation, ownership, or backpressure?
5. Is there a generated artifact or external source of truth?
6. Does the comment include a verifiable condition for remaining true or being removed?
7. Could another developer misuse this API or flow without compiler/test feedback?

If all answers are "no", do not comment.

## Preferred Comment Sections

Use only when needed:
- `Important:`
- `Why:`
- `Assumption:`
- `Constraint:`
- `Invariant:`
- `Risk:`
- `Side Effects:`
- `Concurrency:`
- `Cancellation:`
- `Isolation:`
- `Ownership:`
- `Lifetime:`
- `Observation:`
- `Backpressure:`
- `Performance:`
- `Compatibility:`
- `Generated:`

Prefer the most precise section. Use `Concurrency:` only for broad concurrency context; use `Cancellation:`, `Isolation:`, `Ownership:`, or `Backpressure:` when one of those is the actual risk.

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
- SwiftUI identity, lazy-container state lifetime, and repeatable `onAppear`
- Observation dependencies that are registered implicitly by framework reads
- cancellation boundaries, cleanup, rollback, and point-of-no-return behavior
- actor isolation, task ownership, and non-copyable ownership/lifetime constraints
- stream ordering, cancellation, and backpressure
- generated-code source-of-truth and regeneration boundaries
- local diagnostic exceptions with a removal condition
- performance constraints backed by reproducible evidence
- compatibility workarounds with explicit removal conditions
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
- TODOs without owner, condition, or exit criteria
- "temporary" or workaround comments without version, issue, or removal event
- performance claims without metric, fixture, trace, or benchmark
- comments that contradict types, compiler diagnostics, or tests

## Writing Guardrails

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
- local compatibility or performance constraints

Use DocC articles for:
- architecture explanations
- system flows
- domain concepts
- cross-module behavior
- version-dependent behavior spanning multiple symbols

Generated code boundary:
- do not add manual documentation to generated artifacts;
- document the schema, specification, or stable wrapper that owns the contract;
- include the regeneration command or process when it is not discoverable.

## Compatibility Note

Examples target modern Swift codebases using Swift 6.3+/Xcode 27 concepts, Swift Concurrency, SwiftUI lifecycle behavior, Observation, and generated-code workflows. The principle is retrocompatible with older Swift projects: encode or test what you can, then comment only what remains invisible.

## Examples

- [examples/bad-comments.swift](examples/bad-comments.swift)
- [examples/better-comments.swift](examples/better-comments.swift)
- [examples/concurrency.swift](examples/concurrency.swift)
- [examples/invariants.swift](examples/invariants.swift)
- [examples/api-contracts.swift](examples/api-contracts.swift)
- [examples/pricing-rounding.swift](examples/pricing-rounding.swift)
- [examples/modern-contracts.swift](examples/modern-contracts.swift)

## Additional Resources

- [docs/principles.md](docs/principles.md)
- [docs/context.md](docs/context.md)
- [docs/decision-rules.md](docs/decision-rules.md)
- [docs/checklist.md](docs/checklist.md)
- [docs/example-constraints.md](docs/example-constraints.md)
- [docs/golden-examples.md](docs/golden-examples.md)
- [docs/docc-guidance.md](docs/docc-guidance.md)
- [docs/review-red-flags.md](docs/review-red-flags.md)
