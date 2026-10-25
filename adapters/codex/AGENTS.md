# Codex Adapter - Swift Comments That Matter

Use this adapter to apply the shared standard in Codex-style workflows.

Canonical source:
- `standards/swift-comments-that-matter/STANDARD.md`

## Rules

- Prefer refactoring over low-value comments.
- Keep internal comments for hidden intent, risk, constraints, invariants, side effects, and concurrency assumptions. Preserve useful public API summaries.
- Never start with generic lead-ins like "This function...".
- Keep output concise, specific, and production-oriented.
- Return a final rewrite or deletion; include no/bad/good/best variants when explicitly requested.

## Deep References

- `standards/swift-comments-that-matter/docs/`
- `standards/swift-comments-that-matter/examples/`

Refactor within the authorized scope; in comment-only work, propose code changes
separately. Verify documented claims before treating them as facts. Use
`needs-evidence` and preserve uncertain text provisionally when context is missing.
Keep rationale for deliberate compiler-visible boundaries and verify executor
claims against the module configuration.

## Quick Prompt

"Apply swift-comments-that-matter: refactor-first, then add only comments that encode intent, risk, constraints, or invariants."
