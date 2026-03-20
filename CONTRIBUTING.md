# Contributing

Thanks for contributing to `swift-comments-that-matter`.

## What This Repo Maintains

- A canonical, agent-agnostic standard in `standards/swift-comments-that-matter/`
- Adapter entrypoints in `adapters/`
- Cursor compatibility layer in `skills/swift-comments-that-matter/`

## Contribution Rules

- Keep guidance concise and high-signal.
- Prefer real production scenarios over tutorial examples.
- Preserve the rule: refactor first, comment only for intent/risk/constraints.
- Avoid generic openings ("This function...", "This method...", "This class...").
- Keep tone direct and engineer-to-engineer.

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
- [ ] New examples follow required scenario pattern
- [ ] No low-signal boilerplate comments introduced
- [ ] README/docs remain tool-agnostic by default

## Commit Style

Use descriptive and human commit messages:
- clear summary line
- optional short body with why the change matters
