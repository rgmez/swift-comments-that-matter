## Summary

- Tightened checklist scoring so only relevant criteria count toward comment quality.
- Clarified that the `skills/swift-comments-that-matter/` folder is a portable `SKILL.md` package, not only a Cursor compatibility layer.
- Added CI coverage to catch drift between mirrored standard and skill docs/examples.

## Highlights

### Fairer scoring

The checklist now supports `N/A` for criteria that do not apply to a code path.

This prevents useful comments from being penalized for missing side-effect or concurrency notes when those risks are not present.

### Clearer package positioning

The skill package docs now describe `skills/swift-comments-that-matter/` as the portable entrypoint for runtimes that load `SKILL.md` directly, including Cursor-compatible installs.

### Stronger docs CI

Docs checks now validate that mirrored content remains synchronized:
- `standards/swift-comments-that-matter/docs` vs `skills/swift-comments-that-matter/docs`
- `standards/swift-comments-that-matter/examples` vs `skills/swift-comments-that-matter/examples`

## Full change list

### Changed
- `standards/swift-comments-that-matter/STANDARD.md`
- `standards/swift-comments-that-matter/docs/checklist.md`
- `skills/swift-comments-that-matter/SKILL.md`
- `skills/swift-comments-that-matter/docs/checklist.md`
- `skills/swift-comments-that-matter/README.md`
- `README.md`
- `CONTRIBUTING.md`
- `CHANGELOG.md`

### Added
- Mirrored content validation in `.github/workflows/docs-checks.yml`

## Compatibility notes

- No breaking changes.
- Existing adapters, install paths, and examples remain valid.

## Suggested tag/title

- Tag: `v1.1.2`
- Title: `v1.1.2 - Scoring, packaging, and mirror checks`
