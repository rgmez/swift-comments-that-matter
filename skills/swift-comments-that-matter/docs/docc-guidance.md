# DocC Guidance

## Symbol Summaries

Reference documentation describes observable behavior even when names,
types, or tests already express it. Begin with a concise summary, then document
parameters, returns, errors, and constraints that consumers need. Avoid exposing
private implementation decisions as public guarantees.

Use recognized DocC markup such as `- Parameter name:`, `- Returns:`,
`- Throws:`, and `- Important:` when applicable. Labels such as `Ownership:`
and `Backpressure:` are prose conventions, not dedicated DocC directives.
Use `//` for rationale attached to an implementation step and `///` for a symbol.
These distinctions also apply to internal APIs documented for the team; visibility
alone does not determine whether a useful symbol summary should be removed.

Reference: [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).

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

If consumers need the statement to use one symbol, keep it in its documentation.
If it explains only an implementation step, use a local `//` comment.
If they need broader system context, put it in a DocC article and link it.

If the code is generated, do not patch its documentation by hand. Prefer the
schema/specification when it owns the contract, or a stable wrapper when it owns
local behavior. A DocC documentation extension file can also supplement or
replace source comments for a symbol included in the documentation build.
Confirm that DocC resolves the generated symbol and include regeneration steps
only when they are not discoverable.

A documentation extension targets a symbol, for example:

```markdown
# ``OrdersClient/submit(orderID:)``
```

It is not a free-standing conceptual article. Choose its location in the relevant documentation catalog and verify
symbol resolution in that project.

Reference: [Apple’s documentation catalog guidance](https://developer.apple.com/documentation/Xcode/adding-supplemental-content-to-a-documentation-catalog).

## Verify What Readers See

For changed symbol documentation, inspect the summary, parameter names, return
value, errors, and links in Quick Help or Documentation Preview when available.
Build documentation when links, markup structure, or catalog content change and
the project supports it. Check diagnostics and that the intended symbol pages
include the content; a successful Swift compile or Markdown lint is insufficient.
Do not require a new catalog or Xcode project just to edit a local comment.
Report unavailable preview/build checks rather than claiming rendered validation.

References:
[Writing symbol documentation](https://developer.apple.com/documentation/xcode/writing-symbol-documentation-in-your-source-files),
[Documentation Preview workflow](https://developer.apple.com/videos/play/wwdc2023/10244/?time=485).

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
