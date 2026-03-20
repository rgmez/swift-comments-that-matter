# Principles

## High Signal Over High Volume

A small number of precise comments beats heavy documentation that repeats code.

## Comment For Decisions, Not Mechanics

Comments should capture decisions and their boundaries:
- why this approach exists
- what must remain true
- what can break if behavior changes

## Risk-Centered Writing

Prioritize documenting:
- invariants
- constraints
- side effects
- concurrency assumptions

If no risk or hidden behavior exists, skip the comment.

## Refactor Before Commenting

Naming and structure are the first documentation layer.
Only comment when refactoring cannot make the non-obvious part clear.

## Keep Future Changes Safe

A good comment reduces accidental regressions by preserving key assumptions and contracts during refactors.
