# Example Constraints

All examples must:

- reflect realistic production scenarios
- include trade-offs or limitations
- teach hidden context, useful symbol documentation, or a negative control where no internal comment is best
- label external services and measurements as illustrative when no real implementation or evidence is supplied
- never imply that compiling a stub verifies its documented runtime guarantees
- avoid trivial logic unless a focused negative control needs only a small declaration
- use meaningful domain contexts:
  - authentication
  - payments
  - caching
  - networking
  - state management
  - concurrency

## Required Pattern Per Scenario

Scenarios demonstrating hidden context use:

1. no comment version (clean but incomplete)
2. bad comment version (common anti-pattern)
3. good comment version (useful and concise)
4. best version (staff-level intent + constraints + reasoning)

Negative controls may show only the redundant comment and its deletion.
The four-tier pattern is for teaching, not a required review output format.

## Forbidden Smells

- tutorial-style scaffolding that does not mirror production reality
- overlong comments that do not add risk or decision context
- generic comments that can fit any code snippet
