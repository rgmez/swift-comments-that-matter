# Changelog

All notable changes to this project are documented in this file.

The format is based on Keep a Changelog.

## [Unreleased]

## [1.1.0] - 2026-03-21

### Added
- New canonical example: `pricing-rounding.swift` covering currency-scale rounding constraints and reconciliation safety
- Example index files for faster navigation:
  - `standards/swift-comments-that-matter/examples/README.md`
  - `skills/swift-comments-that-matter/examples/README.md`
- Adoption kit for distribution and social proof:
  - `docs/adoption/README.md`
  - `docs/adoption/before-after.md`
  - `docs/adoption/launch-post.md`
  - `.github/SOCIAL_POST_SHORT.md`
  - `media/README.md`
- Repository formatting guardrails to improve rendering consistency:
  - `.editorconfig`
  - `.gitattributes`

### Changed
- Expanded `standards/swift-comments-that-matter/STANDARD.md` into a stronger canonical reference with:
  - `When Not To Comment`
  - comment section conventions with examples
  - mini quality rubric
  - explicit DocC boundary examples (`///` vs DocC article)
- Updated root `README.md` with:
  - Apple documentation style alignment section
  - iconic example links
  - before/after block
  - adoption asset references
- Updated `skills/swift-comments-that-matter/SKILL.md` and `README.md` to include pricing/rounding coverage and stronger DocC positioning
- Updated `docs/docc-guidance.md` and `docs/golden-examples.md` in both canonical and skills trees for consistency
- Updated `adapters/cursor/README.md` with direct links to demo/adoption assets

### Compatibility
- No breaking changes to folder layout or adapter entrypoints
- Existing install paths remain valid

## [1.0.0] - 2026-03-20

### Added
- Canonical standards tree under `standards/swift-comments-that-matter/`
- Adapter layer for Cursor, Claude, and Codex
- Cursor compatibility layer retained under `skills/swift-comments-that-matter/`
- High-signal Swift comment standard focused on intent, constraints, invariants, side effects, and concurrency notes
- Production-oriented examples with no/bad/good/best tiers
- Decision rules, checklist rubric, DocC boundary guidance, and golden examples
- Installation and verification guidance for each supported tool
- Contribution guidelines and MIT license
- Release template under `.github/RELEASE_TEMPLATE.md`
