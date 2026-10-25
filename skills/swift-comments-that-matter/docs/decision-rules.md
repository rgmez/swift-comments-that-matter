# Decision Rules

## Pre-Comment Gate

Before writing a comment, ask:

1. Can I improve naming instead?
2. Can the type system, actor isolation, ownership, availability, diagnostics, tests, or preconditions express this contract?
3. Is there hidden framework behavior such as prefetch, reentry, or Observation tracking?
4. Does correctness depend on identity, ordering, task-result ownership, lifetime, cancellation, isolation, ownership, or backpressure?
5. Is there a generated artifact or external source of truth?
6. Does the comment have a verifiable condition for staying true or being removed?
7. Will someone misuse this without compiler/test feedback?

Resolve questions 1–2 first. If no hidden context remains in questions 3–7,
omit the internal comment. Useful public API summaries remain valid.

## Contract Hierarchy

Prefer this order:

1. `encode` - make the contract visible to the compiler with names, types, isolation, ownership, availability, diagnostics, or API shape.
2. `test` - make the behavior executable with a unit test, parameterized test, exit test, fixture, benchmark, or precondition.
3. `comment` - explain intent, trade-off, failure mode, or removal condition that remains invisible.
4. `DocC` - move broader system behavior to an article when it spans symbols or modules.

Before writing "must never", ask whether a test, precondition, or compiler boundary
can enforce it. Preserve useful symbol documentation and explanations of why a
boundary is deliberate; neither tests nor inferred annotations preserve that
intent automatically. See [concurrency contracts](concurrency-contracts.md).

## Modern Swift Gates

Check compiler, language mode, SDK/runtime availability, default isolation, and
relevant feature flags before adopting new syntax or executor assumptions.
The [concurrency reference](concurrency-contracts.md) covers those boundaries.

- If a throwing `Task` result is ignored, fix the ownership or error handling. Do
  not explain away the diagnostic with a comment.
- If a task handle is deliberately transferred, comment only the owner that must
  await, cancel, or supervise it and the failure mode if that contract breaks.
- For `@diagnose`, put the declaration-local justification in `reason:`. Use a
  comment only for a non-local consequence or removal event the attribute cannot
  express.
- Keep a cancellation shield around only the required cleanup or commit/rollback
  work. Awaiting cleanup in `defer` does not itself prevent it from observing
  cancellation. A shield does not guarantee atomic writes or successful recovery.

## SwiftUI And Observation Gates

- Never claim an exact lazy-container eviction moment. Off-screen views can stay
  alive for several updates and can later be discarded with their local state.
- Treat `onAppear` as repeatable. Prefetch can evaluate `body` without a later
  `onAppear`, so mandatory one-time setup belongs in an initializer or model.
- Filter repeated lazy content at the data level. A dynamic number of subviews in
  a leaf can force index-based retention and unnecessary off-screen updates.
- Comment an Observation read only when the read exists to register a hidden
  tracked dependency or when back-deployment depends on an external opt-in. Do
  not narrate ordinary `@Observable` use.

## Refactor-First Rule

Try these first:
- rename symbols for clarity
- extract smaller functions
- flatten confusing control flow

If readability improves enough, stop there. In comment-only work, recommend
refactors separately; apply code changes only within the authorized scope.
Verify claims before writing them as facts, and flag missing evidence rather
than inventing a rationale or documenting a bug as an intended contract.

## Rewrite Playbook: No -> Bad -> Good -> Best

Use this sequence for teaching or when four alternatives are requested.
No internal comment can be the best outcome when code already expresses the contract.

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

For ordinary reviews, return the classification, reason, and final rewrite
(or deletion). If correctness depends on missing context, state the evidence gap
and what would resolve it, preserving the existing text provisionally.
When explicitly asked for four alternatives, output:
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
- `needs-evidence` - a claim cannot yet be confirmed or disproved; identify the missing contract, measurement, or owner
- `delete` - adds no useful context or is demonstrably false or obsolete

Do not equate missing evidence with falsehood. Propose verified replacement text
when a comment is inaccurate; delete it only when removal preserves useful context.
For `needs-evidence`, leave the text unchanged until its status can be resolved.
