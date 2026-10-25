# Checklist

Use this checklist for pull requests and automated comment rewrites.

Public API summaries are assessed for accurate observable behavior and usability;
they do not need an additional hidden risk to justify their existence. The
risk-focused checks below apply to internal rationale and contract details.

## Pass/Fail Checks

- Comment explains intent, not mechanics.
- Comment captures at least one real risk, constraint, or invariant.
- Comment avoids generic openings like "This function...".
- Comment is concise and specific to this code path.
- Comment helps a future refactor avoid breaking behavior.
- Comment is not replacing a contract that should live in types, actor isolation, ownership, availability, diagnostics, tests, or preconditions.
- Operational comments include evidence or an exit condition: issue, version, benchmark, trace, fixture, or removal event.
- Generated-code comments point to the source of truth, not the generated artifact.
- Throwing tasks have an explicit error/result owner; comments never excuse an ignored task outcome.
- Cancellation comments state the publication or cleanup policy; shields cover only required cleanup or commit/rollback work.
- Executor claims match the module settings and annotations rather than assuming `async` means background work.
- Deliberate annotations and useful contract rationale survive cleanup even if a type or test enforces the behavior.
- Lazy-container comments avoid exact eviction guarantees and treat `onAppear` as repeatable.
- Diagnostic exceptions use a meaningful `@diagnose(reason:)`; comments add only non-local context or a removal condition.

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

Rewrite redundant implementation narration or demonstrably incorrect claims.
Generic lead-ins are wording problems to improve, not automatic correctness
failures. Useful API summaries need not include hidden risk.

Use `needs-evidence` for unavailable rationale, ownership, measurements, or removal
conditions. State what is missing without inventing proof or deleting a potentially
valid restriction. When a comment contradicts verified behavior, flag the mismatch
and propose an accurate replacement.

For DocC edits, inspect Quick Help or Documentation Preview when available. Build
documentation when symbol links, parameters, or page structure change and the
project supports it; report checks that could not be performed. Markdown lint
and Swift type-checking alone do not verify rendered documentation.

Fail lifecycle guidance that treats an off-screen lazy view as immediately dead or
permanently retained, or treats `onAppear` as guaranteed one-shot initialization.
