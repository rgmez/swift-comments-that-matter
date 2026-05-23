# Contributing

Thanks for contributing to `swift-comments-that-matter`.

## What This Repo Maintains

- A canonical, tool-agnostic standard in `standards/swift-comments-that-matter/`
- Adapter entrypoints in `adapters/`
- Portable skill package in `skills/swift-comments-that-matter/`

## Contribution Rules

- Keep guidance concise and high-signal.
- Prefer real production scenarios over tutorial examples.
- Preserve the rule: refactor first, comment only for intent/risk/constraints.
- Avoid generic openings ("This function...", "This method...", "This class...").
- Keep tone direct and engineer-to-engineer.

## Editorial Style Rules

- Write like a senior engineer talking to another engineer.
- Prefer plain language over polished or generic phrasing.
- Keep each comment short; split long reasoning into bullet sections when needed.
- Do not use boilerplate narration of implementation steps.
- Prefer concrete failure modes over vague warnings.
- Reject wording that sounds robotic, sales-like, or tutorial-heavy.

## Reject Criteria For New Examples

- Trivial logic (getters/setters, toy math, or tutorial snippets).
- No real risk, invariant, or side effect.
- Duplicates an existing scenario without new constraints.
- Explains "what the code does" instead of "what must not break".

## Example Quality Requirements

Every scenario must include:
1. no comment
2. bad comment
3. good comment
4. best comment (intent + constraints + reasoning)

Examples must include realistic risk or constraints and avoid trivial logic.

## Pull Request Checklist

- [ ] Changes align with `standards/swift-comments-that-matter/STANDARD.md`
- [ ] References and links are valid
- [ ] Mirrored `standards/` and `skills/` docs/examples stay synchronized
- [ ] Docs Checks CI passes (`.github/workflows/docs-checks.yml`)
- [ ] New examples follow required scenario pattern
- [ ] No low-signal boilerplate comments introduced
- [ ] README/docs remain tool-agnostic by default

## Commit Style

Use descriptive and human commit messages:
- clear summary line
- optional short body with why the change matters
