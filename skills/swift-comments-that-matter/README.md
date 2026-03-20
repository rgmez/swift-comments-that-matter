# swift-comments-that-matter

A reusable skill for writing high-signal Swift comments in production Apple-platform codebases.

Compatibility note: this folder is the Cursor-compatible packaging layer.
Canonical standard lives at `standards/swift-comments-that-matter/STANDARD.md`.

## What This Skill Optimizes

- intent over implementation narration
- constraints over generic explanation
- maintainability over comment volume
- token-efficient routing for AI agents

## Directory Structure

```text
skills/swift-comments-that-matter/
  SKILL.md
  README.md
  examples/
  docs/
```

## How To Use

1. Start from `SKILL.md`.
2. Follow the decision flow and refactor-first rule.
3. Open only the docs needed for the current task.

## Prompt Snippets

- "Audit these Swift comments using swift-comments-that-matter and score them with the rubric."
- "Rewrite this API doc comment from bad to best using intent, constraints, and side effects."
- "Apply refactor-first, then add only comments that describe risk or invariants."
- "Check DocC boundary: what should stay in `///` vs move to a DocC article?"

## Maintenance Policy

- Versioning: semantic intent (`major.minor.patch`) as guidance quality evolves.
- Add examples only if they introduce a new realistic risk or constraint pattern.
- Reject examples that are tutorial-like, trivial, or duplicate existing patterns.
- Keep `SKILL.md` compact; move details into `docs/*`.

## Definition Of Done

- All required scenarios are covered.
- Each scenario includes no-comment, bad, good, and best tiers.
- Rubric scores can be applied consistently.
- Internal links are valid.
- Style stays direct, human, and non-generic.
