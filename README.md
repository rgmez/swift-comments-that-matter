# swift-comments-that-matter

Most comments do not help.

They repeat what the code already says, or explain things that will change next sprint.

This project takes a different approach:

`Write comments only for what the code cannot explain.`

Internal comments should add context beyond the implementation.
Public API documentation still needs a useful behavior summary.
Comments are often a symptom of weak naming.
Refactor first. Comment risk, contracts, and what must not break.

## Quick Rules

- Do not comment what the code already says.
- Comment what can break.
- Comment assumptions and constraints.
- Comment side effects.
- Comment concurrency risks.
- Prefer compiler-visible contracts and tests before prose.
- Give workarounds, performance notes, and generated-code comments a verifiable source of truth.
- Use `needs-evidence` when context is missing; do not erase a restriction merely because it cannot be verified locally.

## Quick Start (30s)

1. Open `standards/swift-comments-that-matter/STANDARD.md`.
2. Return a final rewrite or deletion; use `no -> bad -> good -> best` for teaching.
3. Apply the PR checklist in this README before merging.

## Non-Goals

- Teaching Swift basics.
- Replacing good naming with comments.
- Writing long documentation for trivial code paths.
- Forcing comments where the code is already explicit.

## Why This Exists

This started from a poll about Swift documentation.

People looked split, but the pattern was simple:

- Code explains what happens.
- Comments explain what must not break.

Poll article:

- [When documentation actually helps (and when it doesn't)](https://www.linkedin.com/pulse/when-documentation-actually-helps-doesnt-roberto-g%C3%B3mez-bvgke/?trackingId=EPUR8ASbhwehJREg2lYQrg%3D%3D)

## Before vs After

```swift
// Before (redundant)
/// Stores the response.
func apply(_ response: SearchResponse) {
    guard response.requestID == activeRequestID else { return }
    results = response.items
}

// After (high-signal)
// Compare request IDs, not query text: A → B → A must not let the first
// response overwrite the final search, even though both queries are equal.
func apply(_ response: SearchResponse) {
    guard response.requestID == activeRequestID else { return }
    results = response.items
}
```

## When NOT To Write Comments

- The code is already clear after normal refactoring.
- The comment repeats the function or type name.
- The logic is trivial and has no hidden risk.
- The comment is likely to rot faster than the code.

For internal implementation comments, consider whether naming or structure can
carry the explanation. Preserve useful public API summaries.

## Painful Real Examples

- Auth refresh race condition:
  - `standards/swift-comments-that-matter/examples/concurrency.swift`
- Cache invalidation constraints:
  - `standards/swift-comments-that-matter/examples/invariants.swift`
- SwiftUI async lifecycle stale-write bug:
  - `standards/swift-comments-that-matter/examples/concurrency.swift`
- Cancellation, SwiftUI lazy lifetime, Observation, generated schemas, and backpressure:
  - `standards/swift-comments-that-matter/examples/modern-contracts.swift`

## Iconic Example: Auth Refresh Race

```swift
// Looks fine, but can fail in production
func refreshSessionIfNeeded() async throws {
    if token.isExpired {
        token = try await authService.refreshToken()
    }
}

// Review outcome: a comment does not fix the concurrent refresh bug.
// Coalesce refreshes in an actor and preserve the reason for that contract:
// simultaneous refreshes may invalidate a rotating token chain.
// See the complete TokenRefresher example in examples/concurrency.swift.
```

## What You Get

- Canonical tool-agnostic standard
- Adapter entrypoints for Cursor, Claude, and Codex
- Production-style Swift examples (`no`, `bad`, `good`, `best`)
- Modern Swift examples for task-result ownership, cancellation, lazy-container prefetch/lifetime, Observation, generated code, and performance evidence
- Decision rules with refactor-first guidance
- Review checklist and scoring rubric
- DocC boundary guidance, documentation extensions for generated symbols, and rendered verification
- Executable checks for cancellation-safe publication and shared download lifetime

## Aligned With Apple Documentation Style

Use inline `///` for symbol-level contracts:

- invariants
- assumptions
- constraints
- side effects

Use DocC articles for system-level context:

- architecture
- multi-step flows
- domain behavior across modules

## PR Review Checklist

Use this quick pass in code review:

- Does this comment explain intent instead of mechanics?
- Does it capture a real risk, constraint, or invariant?
- Could the compiler, type system, actor isolation, ownership, diagnostics, tests, or preconditions enforce this better?
- Does it include evidence or a removal condition when it is operational?
- Would this still be correct after a refactor next month?
- If removed, would we lose safety-critical context?

Full checklist and rubric:

- `standards/swift-comments-that-matter/docs/checklist.md`

## Copy-Paste Ready Examples

- `docs/adoption/before-after.md`
- `standards/swift-comments-that-matter/docs/review-red-flags.md`

## Repository Contents

```text
standards/swift-comments-that-matter/      # canonical standard
adapters/cursor/                           # Cursor adapter
adapters/claude/                           # Claude adapter
adapters/codex/                            # Codex adapter
skills/swift-comments-that-matter/         # portable skill package
```

## Adoption Assets

- `docs/adoption/README.md`
- `docs/adoption/before-after.md`
- `docs/adoption/launch-post.md`

## How To Use

1. Start with `standards/swift-comments-that-matter/STANDARD.md`.
2. Pick your adapter in `adapters/` based on your tooling.
3. Use `skills/swift-comments-that-matter/` when your runtime loads a `SKILL.md` package directly.

## Install by environment

### Option A: skills.sh CLI

Install from GitHub with `skills`:

```bash
npx skills add rgmez/swift-comments-that-matter@swift-comments-that-matter
```

Useful commands:

```bash
# List skills available in this repo
npx skills list rgmez/swift-comments-that-matter

# List installed skills
npx skills list

# Update installed skills
npx skills update
```

### Option B: Cursor (manual local install)

1. Clone this repository locally.
2. Use `skills/swift-comments-that-matter/` as the Cursor-compatible package.
3. Ask Cursor to apply `swift-comments-that-matter` when reviewing or rewriting comments.

Suggested request text:

> "Use swift-comments-that-matter to audit these Swift comments and rewrite only low-signal ones."

### Option C: Claude / Codex (adapter-guided)

Use adapter docs for tool-specific framing:

- `adapters/claude/CLAUDE.md`
- `adapters/codex/AGENTS.md`
- `adapters/cursor/README.md`

Then follow the canonical standard:

- `standards/swift-comments-that-matter/STANDARD.md`

## Verification after install

Run one smoke check and confirm response shape:

> "Review these Swift comments with swift-comments-that-matter. Return no/bad/good/best rewrites and explain what must not break."

Expected:

- uses refactor-first reasoning before adding comments
- avoids generic intros like "This function..."
- includes constraints, risks, side effects, or invariants where relevant

## Validate The Examples

On macOS with Swift 6 installed:

```bash
python3 scripts/check_swift_examples.py
```

The runner type-checks each Swift file and checks cancellation-safe publication,
shared download cleanup/retry, and stream completion without network requests.
It reports skipped scenarios when a newer compiler or runtime is required. DocC
rendering is checked in the consuming project when its documentation is edited.

## Tone And Guardrails

- Human, direct, engineer-to-engineer
- No tutorial voice
- No generic intros like "This function..."
- Keep comments short and specific

## Releases

- Changelog: `CHANGELOG.md`
- Release guide: `.github/RELEASE_TEMPLATE.md`
- Release: `v1.3.0`
- Release notes: [.github/RELEASE_NOTES_1.3.0.md](.github/RELEASE_NOTES_1.3.0.md)

## License

This project is licensed under the MIT License.

- Full license text: [LICENSE](LICENSE)
- Copyright: `Copyright (c) 2026 Roberto Gómez`
