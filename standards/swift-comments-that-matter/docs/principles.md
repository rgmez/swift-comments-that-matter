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

Do not substitute a "not thread-safe" warning for an enforceable boundary.
Tests and preconditions can protect a "must never" invariant while documentation
still explains why it matters. Keep intentional annotations when they preserve an
API guarantee, even if inferred; explain the consequence of changing them.
See [concurrency contracts](concurrency-contracts.md).

A throwing `Task` needs a result owner, not a prose warning. Handle or await its
error, or transfer the handle to a supervisor whose cancellation and teardown
responsibilities are explicit.

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

If no risk or hidden behavior exists, skip the internal comment. Public API
reference documentation can still need an observable-behavior summary; see
[DocC guidance](docc-guidance.md).

## Refactor Before Commenting

Naming and structure are the first documentation layer.
Only comment when refactoring cannot make the non-obvious part clear.

## Keep Future Changes Safe

A good comment reduces accidental regressions by preserving key assumptions and contracts during refactors.

Operational comments should point to an issue, version, fixture, benchmark, trace,
or event that supports revisiting them. When that evidence is unavailable, mark
`needs-evidence` and retain the text provisionally; lack of local evidence is not
proof that a constraint is false.

Framework-managed lifetime is not an implementation guarantee. For lazy SwiftUI
content, document the domain state that must survive and the consequence of
reentry; do not promise when the framework retains, prefetches, or evicts a view.
