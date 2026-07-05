# Decision Rules

## Pre-Comment Gate

Before writing a comment, ask:

1. Can I improve naming instead?
2. Can the type system, actor isolation, ownership, availability, diagnostics, tests, or preconditions express this contract?
3. Is there hidden framework behavior?
4. Does correctness depend on identity, ordering, lifetime, cancellation, isolation, ownership, or backpressure?
5. Is there a generated artifact or external source of truth?
6. Does the comment have a verifiable condition for staying true or being removed?
7. Will someone misuse this without compiler/test feedback?

If all answers are "no", do not write a comment.

## Contract Hierarchy

Prefer this order:

1. `encode` - make the contract visible to the compiler with names, types, isolation, ownership, availability, diagnostics, or API shape.
2. `test` - make the behavior executable with a unit test, parameterized test, exit test, fixture, benchmark, or precondition.
3. `comment` - explain intent, trade-off, failure mode, or removal condition that remains invisible.
4. `DocC` - move broader system behavior to an article when it spans symbols or modules.

Before writing "must never", ask whether `#expect`, a precondition, a test fixture, or a compiler-enforced boundary would protect the contract better.

## Refactor-First Rule

Try these first:
- rename symbols for clarity
- extract smaller functions
- flatten confusing control flow

If readability improves enough, stop there.

## Rewrite Playbook: No -> Bad -> Good -> Best

Use this sequence when reviewing existing comments.

### 1) No Comment

Code may look clean but miss critical context.
Add a comment only if hidden risk or a non-obvious contract exists.

### 2) Bad Comment

Typical anti-patterns:
- paraphrases the implementation
- starts with "This function/method/class..."
- generic text with zero decision context

### 3) Good Comment

Make it useful:
- explain intent or constraint
- mention one concrete risk
- keep it short

### 4) Best Comment

Staff-level quality:
- states intent
- states what must not break
- includes constraint/assumption
- includes reasoning or trade-off

## Output Rule

When generating alternatives, always output all four levels:
- no comment
- bad
- good
- best

## Audit Classification

When reviewing existing comments, classify each one:

- `keep` - high-signal and still accurate
- `refactor` - naming or structure should carry the meaning
- `encode` - compiler-visible contract should replace prose
- `test` - executable behavior should replace or back the statement
- `move-to-DocC` - context is broader than one symbol
- `delete` - repeats implementation, is unverifiable, or has rotted
