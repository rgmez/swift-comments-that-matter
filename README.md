# swift-comments-that-matter

A practical Cursor skill for writing high-value comments in Swift codebases.

This project helps developers and AI assistants document what actually matters:
- why code exists
- what must not break
- assumptions, constraints, and side effects

If a sentence explains what the code already does, refactor the code.
If it explains risk, intent, or contracts, keep the comment.

## Repository Contents

```text
skills/swift-comments-that-matter/
  SKILL.md
  README.md
  examples/
  docs/
```

## What You Get

- A production-oriented `SKILL.md` with strict routing and guardrails
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

1. Open `skills/swift-comments-that-matter/SKILL.md`.
2. Follow the decision flow and refactor-first rule.
3. Use `docs/checklist.md` to score and review output quality.
4. Use `examples/` as reference patterns for rewrite quality.

## Tone And Guardrails

- Human, direct, engineer-to-engineer
- No tutorial voice
- No generic intros like "This function..."
- Keep comments short and specific

## License

No license specified yet.
