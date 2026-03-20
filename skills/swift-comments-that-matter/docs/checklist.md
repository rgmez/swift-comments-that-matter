# Checklist

Use this checklist for pull requests and AI-generated comment rewrites.

## Pass/Fail Checks

- Comment explains intent, not mechanics.
- Comment captures at least one real risk, constraint, or invariant.
- Comment avoids generic openings like "This function...".
- Comment is concise and specific to this code path.
- Comment helps a future refactor avoid breaking behavior.

## Scoring Rubric (0-2)

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
- `brevity`
  - 0: verbose or noisy
  - 1: acceptable but padded
  - 2: concise and high-signal

## Suggested Thresholds

- 10-12: strong
- 7-9: acceptable but improvable
- 0-6: rewrite required
