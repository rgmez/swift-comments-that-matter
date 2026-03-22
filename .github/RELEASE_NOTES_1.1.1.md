## Summary

- Tightened the repo voice and positioning to feel more direct, practical, and authorial.
- Added docs quality automation (markdown lint + local link validation).
- Added review red flags docs to make PR review faster and more consistent.

## Highlights

### README quality jump

The root `README.md` now includes:
- stronger opening and clearer point of view
- `Quick Start (30s)` for immediate use
- `Non-Goals` to prevent misuse
- an iconic auth refresh race example
- link to the original poll article

### Review ergonomics

Added explicit review anti-pattern references:
- `standards/swift-comments-that-matter/docs/review-red-flags.md`
- `skills/swift-comments-that-matter/docs/review-red-flags.md`

These are designed for quick PR scans and rewrite guidance.

### Docs CI

Added `Docs Checks` workflow:
- markdown lint (`markdownlint-cli`)
- local markdown link validation (`scripts/check_markdown_local_links.py`)

Also aligned lint configuration with existing repository doc style.

## Full change list

### Added
- `.github/workflows/docs-checks.yml`
- `.markdownlint.json`
- `scripts/check_markdown_local_links.py`
- `standards/swift-comments-that-matter/docs/review-red-flags.md`
- `skills/swift-comments-that-matter/docs/review-red-flags.md`

### Changed
- `README.md`
- `CONTRIBUTING.md`
- `adapters/cursor/README.md`
- `docs/adoption/README.md`
- `docs/adoption/launch-post.md`
- `standards/swift-comments-that-matter/STANDARD.md`
- `standards/swift-comments-that-matter/README.md`
- `standards/swift-comments-that-matter/docs/checklist.md`
- `standards/swift-comments-that-matter/docs/context.md`
- `skills/swift-comments-that-matter/SKILL.md`
- `skills/swift-comments-that-matter/README.md`
- `skills/swift-comments-that-matter/docs/checklist.md`
- `skills/swift-comments-that-matter/docs/context.md`
- `CHANGELOG.md`

### Removed
- `.github/SOCIAL_POST_SHORT.md`

## Compatibility notes

- No breaking changes.
- Existing adapters, paths, and usage flow remain valid.

## Suggested tag/title

- Tag: `v1.1.1`
- Title: `v1.1.1 - README polish, docs CI, and review red flags`
