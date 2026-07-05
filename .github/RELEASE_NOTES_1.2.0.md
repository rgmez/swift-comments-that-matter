## Summary

- Evolves the skill for modern Swift 6.3+/Xcode 27-era codebases while keeping the original refactor-first principle intact.
- Adds precise comment signals for cancellation, isolation, ownership, lifetime, backpressure, generated code, compatibility, and performance evidence.
- Includes new no/bad/good/best examples for SwiftUI lazy lifetime, `.task(id:)` reentry, Observation dependency reads, generated schemas, stream ordering, and measured performance constraints.
- No breaking changes.

## Why this release

- Swift, SwiftUI, Observation, generated-code workflows, and coding-agent usage now expose contracts that prose should not pretend to own when the compiler or tests can enforce them better.
- This release teaches the stronger hierarchy: encode contracts in code first, verify them with tests when possible, then comment only the remaining invisible intent, boundary, trade-off, or removal condition.
- It also raises the bar for operational comments so TODOs, workarounds, generated-code notes, and performance claims stay verifiable instead of becoming stale authority.

## Compatibility notes

- No breaking changes.
- Existing install paths, adapters, standard paths, and portable `SKILL.md` package layout remain valid.
- Existing Swift 5.9+ examples and workflows remain usable; the new guidance adds modern Swift/SwiftUI coverage without requiring consumers to migrate immediately.

## Test plan

- [x] Validate standard references resolve
- [x] Validate adapter docs point to canonical paths
- [x] Validate no/bad/good/best examples remain aligned
- [x] Type-check the new `modern-contracts.swift` example
- [x] Validate mirrored `standards/` and `skills/` docs/examples remain in sync
