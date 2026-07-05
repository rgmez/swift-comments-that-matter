# Principles

## High Signal Over High Volume

A small number of precise comments beats heavy documentation that repeats code.

## Comment For Decisions, Not Mechanics

Comments should capture decisions and their boundaries:
- why this approach exists
- what must remain true
- what can break if behavior changes

## Compiler And Tests Before Prose

Use the strongest source of truth available:
- types, ownership, actor isolation, availability, diagnostics, and API shape for compilable contracts
- tests, preconditions, or fixtures for executable contracts
- comments for intent, trade-offs, removal conditions, and failure modes that remain invisible
- DocC for behavior that spans symbols, modules, or domain workflows

Do not write "not thread-safe" if isolation, `Sendable`/`~Sendable`, or an actor boundary can make the contract explicit. Do not write "must never" if a test or precondition can enforce it.

## Risk-Centered Writing

Prioritize documenting:
- invariants
- constraints
- side effects
- concurrency assumptions
- cancellation and rollback boundaries
- isolation, ownership, lifetime, and backpressure
- generated-code sources of truth
- compatibility or performance constraints with removal/evidence

If no risk or hidden behavior exists, skip the comment.

## Refactor Before Commenting

Naming and structure are the first documentation layer.
Only comment when refactoring cannot make the non-obvious part clear.

## Keep Future Changes Safe

A good comment reduces accidental regressions by preserving key assumptions and contracts during refactors.

Operational comments must include a condition that keeps them honest: an issue, version, fixture, benchmark, trace, or event that says when the comment should be revisited or removed.
