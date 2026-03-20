# Example Constraints

All examples must:

- reflect realistic production scenarios
- include trade-offs or limitations
- include at least one hidden risk (race condition, assumption, side effect, contract trap)
- avoid trivial logic (no `add(a, b)`, no basic getters)
- use meaningful domain contexts:
  - authentication
  - payments
  - caching
  - networking
  - state management
  - concurrency

## Required Pattern Per Scenario

Each scenario must include:

1. no comment version (clean but incomplete)
2. bad comment version (common anti-pattern)
3. good comment version (useful and concise)
4. best version (staff-level intent + constraints + reasoning)

## Forbidden Smells

- tutorial-style scaffolding that does not mirror production reality
- overlong comments that do not add risk or decision context
- generic comments that can fit any code snippet
