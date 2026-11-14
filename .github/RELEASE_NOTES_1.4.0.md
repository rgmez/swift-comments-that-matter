## Summary

- Separates verified errors, optional wording improvements, and missing evidence so comment reviews preserve useful contracts.
- Protects tooling directives, generator markers, and required notices during editorial cleanup.
- Adds seven review-behavior cases and makes actionable findings the default output, with complete inventories when requested.

## Why this release

The checklist previously presented stylistic openings as pass/fail checks while
other guidance treated them as optional improvements. The standard, portable
skill, and detailed references now use consistent decision criteria. Rubric
scores guide review rather than automatically requiring a rewrite or deletion.

Comments used by tools and required notices are explicitly preserved, including
their placement and scope. Ordinary reviews omit unchanged-comment inventories;
explicit audits can still classify every comment.

The new manual evaluation covers useful API summaries, unavailable provider
evidence, redundant narration, tooling and notices, a code defect against a
maintained contract, concise reviews, and complete inventories. It supplements
the existing Swift example and runtime checks.

## Compatibility notes

- No breaking changes to install paths, adapters, review classifications, or example APIs.
- The portable package now includes the MIT license for standalone installations.
- The documented CLI discovery command now uses `skills add <source> --list`.
- Behavior evaluation is manual and separate from CI; it does not establish real application, provider, generator, or rendered DocC correctness.
- This release also includes the required macOS 27 cleanup CI gate and post-release v1.3.0 validation already recorded on `main`.

## Test plan

- [x] Check local Markdown links, mirrored docs/examples, and `git diff --check`.
- [x] Validate the portable skill with `quick_validate.py`.
- [x] Independently evaluate all seven review requests and inspect the actual responses against a withheld rubric: 7/7 passed in one batch, without isolated per-case contexts.

- [x] Run Markdown lint 0.50.0 and verify all 21 package files after project-scope installation for Codex, Claude Code, and Cursor with skills CLI 1.8.1 and telemetry disabled.

Local publication checks are recorded in the
[release validation receipt](../docs/audit/evidence/release-1.4.0.md).
CI results are linked from the published release.
No consuming DocC project was built. The manual cases evaluate review decisions,
not live tooling or external provider contracts.
