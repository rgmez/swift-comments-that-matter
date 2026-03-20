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

## Installation By Tool

### Cursor

1. Keep this repository cloned locally.
2. Use `skills/swift-comments-that-matter/` as the Cursor-compatible skill package.
3. Ask your agent to apply `swift-comments-that-matter` when reviewing or rewriting Swift comments.

### Claude

1. Open `adapters/claude/CLAUDE.md`.
2. Apply the rules in that adapter plus `standards/swift-comments-that-matter/STANDARD.md`.
3. Use the docs/examples references for deep guidance.

### Codex

1. Open `adapters/codex/AGENTS.md`.
2. Apply its operational rules with the canonical standard.
3. Use scenario files in `standards/swift-comments-that-matter/examples/` to drive no/bad/good/best rewrites.

## How To Verify Installation

- The assistant cites or follows:
  - `standards/swift-comments-that-matter/STANDARD.md`
  - one adapter file under `adapters/`
- Output respects refactor-first and avoids generic intros.
- Rewrites include constraints, risks, or invariants where relevant.

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
