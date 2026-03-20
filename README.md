# swift-comments-that-matter

A cross-agent standard for writing high-value comments in Swift codebases.

This project helps developers and AI assistants document what actually matters:
- why code exists
- what must not break
- assumptions, constraints, and side effects

If a sentence explains what the code already does, refactor the code.
If it explains risk, intent, or contracts, keep the comment.

## Repository Contents

```text
standards/swift-comments-that-matter/      # canonical standard
adapters/cursor/                           # Cursor adapter
adapters/claude/                           # Claude adapter
adapters/codex/                            # Codex adapter
skills/swift-comments-that-matter/         # Cursor compatibility layer
```

## What You Get

- A canonical agent-agnostic standard
- Adapter entrypoints for Cursor, Claude, and Codex
- Realistic Swift examples (no-comment, bad, good, best)
- Decision rules and refactor-first guidance
- Review checklist with a simple scoring rubric
- DocC boundary guidance (`///` vs DocC article)

## Covered Scenarios

- Token refresh concurrency issues
- Download manager deduplication invariants
- Cache eviction assumptions
- Payment business constraints
- SwiftUI async lifecycle edge cases
- Background task scheduling limits
- Analytics side effects
- Public API contracts in frameworks

## How To Use

1. Start with `standards/swift-comments-that-matter/STANDARD.md`.
2. Pick your adapter in `adapters/` based on your assistant.
3. Use `skills/swift-comments-that-matter/` only for Cursor compatibility.

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

Suggested prompt:

> "Use swift-comments-that-matter to audit these Swift comments and rewrite only low-signal ones."

### Option C: Claude / Codex (adapter-guided)

Use adapter docs for tool-specific framing:
- `adapters/claude/CLAUDE.md`
- `adapters/codex/AGENTS.md`
- `adapters/cursor/README.md`

Then follow the canonical standard:
- `standards/swift-comments-that-matter/STANDARD.md`

## Verification after install

Run one smoke prompt and confirm response shape:

> "Review these Swift comments with swift-comments-that-matter. Return no/bad/good/best rewrites and explain what must not break."

Expected:
- uses refactor-first reasoning before adding comments
- avoids generic intros like "This function..."
- includes constraints, risks, side effects, or invariants where relevant

## Tone And Guardrails

- Human, direct, engineer-to-engineer
- No tutorial voice
- No generic intros like "This function..."
- Keep comments short and specific

## Releases

- Changelog: `CHANGELOG.md`
- Release template: `.github/RELEASE_TEMPLATE.md`

## License

MIT. See `LICENSE`.
