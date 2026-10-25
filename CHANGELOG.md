# Changelog

All notable changes to this project are documented in this file.

The format is based on Keep a Changelog.

## [Unreleased]

### Fixed
- Added a required macOS 27 / Swift 6.4 CI job for shielded async cleanup; unsupported environments fail instead of silently skipping it.

### Validation
- Verified the v1.3.0 cleanup example and assertions on macOS 27.0.1, Xcode 27.1, and Swift 6.4 after release.

## [1.3.0] - 2026-10-25

### Added
- Added `needs-evidence` for unresolved claims without deleting potentially valid constraints.
- Added Apple-backed guidance for intentional annotations, executor configuration, async cleanup, and DocC extension files.
- Added a Swift 6.4 async-cleanup example with explicit platform availability and a bounded in-memory resource model.
- Added executable Swift regression checks and a macOS CI job for example behavior.
- Added public API documentation guidance, evidence checks, and scope boundaries for comment-only reviews.
- Added negative controls where compiler-visible contracts make internal comments unnecessary.
- Added WWDC26 guidance for throwing-task result ownership, lazy-container prefetch/reentry, and scoped diagnostic exceptions.
- Added golden and Swift examples for unobserved task failures and repeatable `onAppear` behavior.

### Changed
- Simplified the portable skill entrypoint and routed conditional details to focused references.
- Fixed cancelled loads publishing stale UI state and made download deduplication actor-isolated with identity-safe completion cleanup.
- Separated wording improvements from correctness failures and preserved rationale for compiler-enforced contracts.
- Corrected the research report attribution for Apple's short cancellation-shield recommendation.
- Reserved four-tier alternatives for teaching or explicit comparison requests.
- Corrected stream ordering versus producer backpressure and normal completion semantics.
- Made upload leases non-copyable and Observation dependencies observable in the modern examples.
- Changed the search example to use request identity and cancellation checks, covering A-to-B-to-A reentry.
- Replaced unsupported analytics/idempotency claims in the README example and labeled illustrative evidence.
- Clarified that cancellation shields should cover only the commit/rollback region that must finish.
- Corrected lazy-container guidance to avoid guarantees about immediate eviction or permanent retention.
- Clarified that `@diagnose(reason:)` owns the local justification while comments carry only broader consequences or removal conditions.

### Compatibility
- No breaking changes to install paths, adapter entrypoints, or package layout.
- Ordinary reviews now return a recommendation and final rewrite or deletion; request four-tier alternatives explicitly for teaching or comparison.
- Public API summaries remain valid even when types or tests express their behavior.

## [1.2.1] - 2026-08-05

### Added
- Added `Observation:` as an explicit supported comment signal in the skill entrypoint and canonical standard.
- Added `modern-contracts.swift` coverage for compiler-enforced isolation, ownership and borrowed lifetime, compatibility fallbacks, and scoped diagnostic exceptions.
- Added golden examples for compiler contracts over prose, ownership/lifetime boundaries, and compatibility removal conditions.

### Changed
- Expanded the modern-contracts example index to make the added WWDC26 coverage easier to discover.
- Clarified that local diagnostic exceptions should include a removal condition.

### Compatibility
- No breaking changes to folder layout, adapter entrypoints, or install paths.

## [1.2.0] - 2026-07-05

### Added
- Added modern Swift contract guidance for cancellation, isolation, ownership, lifetime, backpressure, generated code, compatibility, and performance evidence.
- Added `modern-contracts.swift` examples covering cancellation point-of-no-return, SwiftUI lazy lifetime, `.task(id:)` stale completion, Observation dependency reads, generated schemas, stream backpressure, and measured performance constraints.
- Added audit classifications for existing comments: `keep`, `refactor`, `encode`, `test`, `move-to-DocC`, and `delete`.
- Added WWDC26 staff review research notes under `docs/research/`.

### Changed
- Updated the decision flow to prefer compiler-visible contracts and executable tests before comments.
- Expanded DocC guidance with generated-code, version-dependent behavior, and local performance/compatibility boundaries.
- Strengthened review red flags for TODOs, temporary workarounds, performance claims without evidence, and comments that contradict types or tests.
- Updated root README, portable skill package, and canonical standard to reflect the Swift 6.3+/Xcode 27-oriented taxonomy while preserving the original refactor-first principle.

### Compatibility
- No breaking changes to folder layout, adapter entrypoints, or install paths.
- Existing Swift 5.9+ guidance remains valid; the new rules add stronger defaults for modern Swift and SwiftUI projects.

## [1.1.2] - 2026-05-23

### Changed
- Clarified that checklist scoring applies only to relevant criteria, so comments are not penalized for missing side-effect or concurrency notes when those risks do not exist.
- Added `Risk:` as an explicit supported comment section in the canonical standard and skill entrypoint.
- Clarified that `skills/swift-comments-that-matter/` is a portable `SKILL.md` package, not only a Cursor compatibility layer.
- Added a CI check to catch drift between mirrored `standards/` and `skills/` docs/examples.

## [1.1.1] - 2026-03-22

### Added
- New review anti-pattern references:
  - `standards/swift-comments-that-matter/docs/review-red-flags.md`
  - `skills/swift-comments-that-matter/docs/review-red-flags.md`
- Docs CI workflow:
  - `.github/workflows/docs-checks.yml`
  - local markdown link checker under `scripts/check_markdown_local_links.py`

### Changed
- Reworked root `README.md` with stronger positioning and usability:
  - sharper opening and direct "what to do" guidance
  - `Quick Start (30s)` and `Non-Goals`
  - iconic auth refresh race example and poll article reference
  - expanded copy-paste section and PR review guidance
- Expanded editorial contribution rules in `CONTRIBUTING.md`:
  - style rules
  - reject criteria for weak examples
  - docs CI check in PR checklist
- Removed social-post artifact and related references:
  - `.github/SOCIAL_POST_SHORT.md`
- Normalized wording across docs to avoid AI-first framing and keep tone authorial/tool-agnostic
- Tuned markdownlint configuration to match repository doc style while keeping docs checks active

### Compatibility
- No breaking changes
- Existing install paths, adapters, and examples remain valid

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
- Updated `adapters/cursor/README.md` with direct links to adoption assets

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
