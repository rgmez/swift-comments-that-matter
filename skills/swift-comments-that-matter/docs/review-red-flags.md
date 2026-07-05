# Review Red Flags

Use this list during PR review to spot low-signal comments fast.

## Red Flags

- Starts with "This function..." or "This method..."
- Repeats the function name with no extra context
- Narrates obvious control flow line-by-line
- States intent without any boundary, risk, or consequence
- Uses generic warnings like "be careful" with no failure mode
- Adds prose where naming/refactor would solve the problem
- Adds prose where types, isolation, ownership, diagnostics, tests, or preconditions should enforce the contract
- Sounds timeless, but will rot after a small refactor
- Uses `TODO`, `temporary`, or `workaround` without owner, issue, version, or removal condition
- Claims performance wins without a metric, fixture, trace, benchmark, or budget
- Documents generated output instead of the schema/specification/wrapper that owns the contract
- Says `Concurrency:` when the actual risk is cancellation, isolation, ownership, lifetime, ordering, or backpressure

## Quick Rewrite Pattern

From:

- "This method refreshes the token."

To:

- "Concurrency: only one refresh may run per account."
- "Risk: parallel refreshes can invalidate token chain order."

From:

- "This function stores cache data."

To:

- "Constraint: caller must validate cacheability before calling."
- "Side Effects: stale writes can shadow fresher network responses."

## Reviewer Prompts

- What breaks if this behavior changes silently?
- Which assumption is hidden here?
- Is there a side effect that future maintainers can miss?
- Could the compiler or a test enforce this instead?
- What event makes this workaround/comment obsolete?
- Is the source of truth the code being edited, or a schema/generated artifact?
- If we delete this comment, do we lose safety-critical context?
