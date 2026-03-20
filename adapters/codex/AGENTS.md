# Codex Adapter - Swift Comments That Matter

Use this adapter to apply the shared standard in Codex-style workflows.

Canonical source:
- `standards/swift-comments-that-matter/STANDARD.md`

## Rules

- Prefer refactoring over low-value comments.
- Write comments only for hidden intent, risk, constraints, invariants, side effects, and concurrency assumptions.
- Never start with generic lead-ins like "This function...".
- Keep output concise, specific, and production-oriented.
- Include no/bad/good/best variants when asked for rewrites.

## Deep References

- `standards/swift-comments-that-matter/docs/`
- `standards/swift-comments-that-matter/examples/`

## Quick Prompt

"Apply swift-comments-that-matter: refactor-first, then add only comments that encode intent, risk, constraints, or invariants."
