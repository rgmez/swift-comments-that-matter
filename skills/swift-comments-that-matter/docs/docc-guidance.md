# DocC Guidance

## Boundary Rule

Use inline `///` comments for:
- contracts
- invariants
- assumptions
- side effects

Use DocC articles for:
- architecture explanations
- system flows
- domain concepts
- cross-module behavior

## Good Inline Comment Targets

Choose `///` when the statement must stay close to the symbol:
- public API behavior guarantees
- non-obvious preconditions/postconditions
- idempotency and retry constraints
- threading and actor assumptions

## Move To DocC Article When

Move content to a DocC article if it requires:
- sequence diagrams or long flows
- interactions across many types/modules
- broader domain language and concepts

## Practical Rule

If a developer needs the statement while editing one symbol, keep it in `///`.
If they need broader system context, put it in a DocC article and link it.
