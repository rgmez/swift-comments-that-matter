# Checklist

Use this checklist for pull requests and automated comment rewrites.

## Pass/Fail Checks

- Comment explains intent, not mechanics.
- Comment captures at least one real risk, constraint, or invariant.
- Comment avoids generic openings like "This function...".
- Comment is concise and specific to this code path.
- Comment helps a future refactor avoid breaking behavior.
- Comment is not replacing a contract that should live in types, actor isolation, ownership, availability, diagnostics, tests, or preconditions.
- Operational comments include evidence or an exit condition: issue, version, benchmark, trace, fixture, or removal event.
- Generated-code comments point to the source of truth, not the generated artifact.

## Scoring Rubric (0-2, Relevant Criteria Only)

Score each criterion from 0 to 2:

- `intent`
  - 0: missing
  - 1: implied but vague
  - 2: explicit and concrete
- `risk`
  - 0: missing
  - 1: generic warning
  - 2: specific failure mode or misuse risk
- `constraint`
  - 0: missing
  - 1: partial
  - 2: clear boundary or must-not-break rule
- `side effects`
  - 0: missing
  - 1: hinted
  - 2: explicit external/state impact
- `concurrency`
  - 0: ignored where relevant
  - 1: mentioned without clear condition
  - 2: explicit isolation/cancellation/order assumptions
- `lifetime/ownership`
  - 0: ignored where relevant
  - 1: vague ownership or lifetime note
  - 2: explicit owner, transfer, retention, teardown, or lazy-state boundary
- `verifiability`
  - 0: unverifiable claim
  - 1: partially tied to issue, test, or measurement
  - 2: clear compiler/test/evidence/removal condition
- `brevity`
  - 0: verbose or noisy
  - 1: acceptable but padded
  - 2: concise and high-signal

Use `N/A` for criteria that do not apply to the code path. A local value-transforming helper, for example, should not lose points for missing side effects or concurrency notes when neither exists.

## Suggested Thresholds

- 85-100% of applicable points: strong
- 60-84% of applicable points: acceptable but improvable
- below 60% of applicable points: rewrite required

Always fail a comment, regardless of score, when it repeats implementation, starts with a forbidden generic lead-in, or invents a risk that is not present in the code.

Also fail comments that look authoritative but cannot be verified: TODOs without an owner or exit condition, workarounds without a version/issue/removal event, performance claims without reproducible evidence, or comments that contradict the type system/tests.
