## Summary

- Strengthened the canonical `swift-comments-that-matter` standard to improve clarity, authority, and day-to-day usability.
- Added a new production-style pricing/rounding example and expanded golden references.
- Added an adoption kit (before/after snippets + launch copy) so this release is easier to share and onboard.

## Highlights

### Canonical standard upgrades

`standards/swift-comments-that-matter/STANDARD.md` now includes:
- a dedicated `When Not To Comment` section
- preferred comment section conventions (`Why`, `Constraint`, `Invariant`, etc.) with examples
- a mini quality rubric
- explicit DocC boundary examples (`///` for symbol contracts, DocC articles for cross-symbol/system context)

### New iconic example

- Added `pricing-rounding.swift` in both canonical and skills trees to cover:
  - currency-scale rounding constraints
  - must-not-break settlement/reconciliation behavior

### Better discoverability and adoption

- Added example index files:
  - `standards/swift-comments-that-matter/examples/README.md`
  - `skills/swift-comments-that-matter/examples/README.md`
- Added adoption assets:
  - `docs/adoption/before-after.md`
  - `docs/adoption/launch-post.md`
  - `.github/SOCIAL_POST_SHORT.md`
  - `media/README.md`
- Updated root README and Cursor adapter docs to surface these paths directly

## Why this release

Version `1.1.0` focuses on moving from a solid foundation to a publish-ready, reusable reference:
- stronger canonical guidance
- clearer Apple/DocC alignment
- easier external distribution and proof-of-value

## Full change list

### Added
- `standards/swift-comments-that-matter/examples/pricing-rounding.swift`
- `skills/swift-comments-that-matter/examples/pricing-rounding.swift`
- `standards/swift-comments-that-matter/examples/README.md`
- `skills/swift-comments-that-matter/examples/README.md`
- `docs/adoption/README.md`
- `docs/adoption/before-after.md`
- `docs/adoption/launch-post.md`
- `.github/SOCIAL_POST_SHORT.md`
- `media/README.md`
- `.editorconfig`
- `.gitattributes`

### Changed
- `CHANGELOG.md`
- `README.md`
- `adapters/cursor/README.md`
- `standards/swift-comments-that-matter/STANDARD.md`
- `standards/swift-comments-that-matter/README.md`
- `standards/swift-comments-that-matter/docs/docc-guidance.md`
- `standards/swift-comments-that-matter/docs/golden-examples.md`
- `skills/swift-comments-that-matter/SKILL.md`
- `skills/swift-comments-that-matter/README.md`
- `skills/swift-comments-that-matter/docs/docc-guidance.md`
- `skills/swift-comments-that-matter/docs/golden-examples.md`

## Compatibility notes

- No breaking changes.
- Existing repository paths and adapter entrypoints stay valid.
- This is a docs/guidance expansion release.

## Test/Validation checklist

- [x] Standard references resolve from root README
- [x] Cursor adapter points to canonical source
- [x] Required scenario list includes pricing/rounding in canonical and skills docs
- [x] New examples are present in both trees (`standards/` and `skills/`)
- [x] Rendering consistency guardrails added (`.editorconfig`, `.gitattributes`)

## Suggested tag/title

- Tag: `v1.1.0`
- Title: `v1.1.0 - Stronger canonical standard, pricing example, and adoption kit`
