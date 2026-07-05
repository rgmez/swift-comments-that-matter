# DocC Guidance

## Boundary Rule

Use inline `///` comments for:
- contracts
- invariants
- assumptions
- side effects
- symbol-local cancellation, isolation, ownership, lifetime, compatibility, or performance constraints

Use DocC articles for:
- architecture explanations
- system flows
- domain concepts
- cross-module behavior
- version-dependent or generated-code workflows spanning multiple symbols

## Good Inline Comment Targets

Choose `///` when the statement must stay close to the symbol:
- public API behavior guarantees
- non-obvious preconditions/postconditions
- idempotency and retry constraints
- threading and actor assumptions
- local generated-code wrappers where the schema owns the real contract
- measured performance budgets tied to the edited symbol

## Move To DocC Article When

Move content to a DocC article if it requires:
- sequence diagrams or long flows
- interactions across many types/modules
- broader domain language and concepts
- generated-code regeneration policy or schema compatibility strategy
- migration guidance across OS, Swift, or SDK versions

## Practical Rule

If a developer needs the statement while editing one symbol, keep it in `///`.
If they need broader system context, put it in a DocC article and link it.

If the code is generated, do not document the generated file manually. Document the schema/specification or the stable wrapper, and include regeneration steps only when they are not obvious from the project.

## Boundary Examples

Use `///` when the guarantee is local to one symbol:

```swift
/// Constraint: empty IDs fail fast and never hit transport.
public func fetchProfile(userID: String) async throws -> Data
```

Use DocC article content when behavior spans many symbols:

```markdown
# Payment Pipeline
Explains quote creation, authorization windows, capture timing, and reconciliation strategy across modules.
```
