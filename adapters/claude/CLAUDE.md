# Claude Adapter - Swift Comments That Matter

Apply the canonical standard from:
- `standards/swift-comments-that-matter/STANDARD.md`

## Operating Rules

1. Refactor-first before writing comments.
2. Keep internal comments for intent, invariants, constraints, side effects, or concurrency assumptions. Preserve useful public API summaries.
3. Avoid implementation narration and generic intros.
4. Use no comment -> bad -> good -> best for teaching or when explicitly requested; ordinary reviews need only the final recommendation.
5. Keep comments concise and risk-oriented.

## Reference Materials

- `standards/swift-comments-that-matter/docs/`
- `standards/swift-comments-that-matter/examples/`

Refactor within the authorized scope; in comment-only work, propose code changes
separately. Verify documented claims before treating them as facts. Use
`needs-evidence` and preserve uncertain text provisionally when context is missing.
Keep rationale for deliberate compiler-visible boundaries and verify executor
claims against the module configuration.

## Quick Prompt

"Use swift-comments-that-matter to transform these comments from no/bad/good/best and explain what must not break."
