# v1.4.0 Validation Receipt

Date: 2026-11-14. Base revision: `747d870b35028b33e8feb1f6d4626eff9389f42e`.

## Scope And Evidence

- Manual behavior evaluation: seven of seven cases passed after primary-agent review of the actual responses against the withheld rubric. One independent evaluator handled the cases in a single batch; contexts were not isolated per case.
- Evaluation inputs and acceptance criteria: [review behavior evaluation](../../../tests/skill-review/README.md).
- Before release packaging, all 14 file hashes from the earlier evaluation record matched. Packaging then added only `license: MIT` to the skill frontmatter, a bundled license, and a local license link; review instructions and cases remained unchanged.
- Local Markdown links, mirrored docs/examples, official skill validation, Markdown lint 0.50.0, and `git diff --check` passed.
- CLI installation: skills 1.8.1, project scope, copy mode, telemetry disabled. All 21 portable package files matched source bytes, including LICENSE.
- Codex and Cursor use the shared `.agents/skills/swift-comments-that-matter` destination in this CLI version; Claude Code uses `.claude/skills/swift-comments-that-matter`.

## Limits

The behavior evaluation does not verify live provider contracts, generator/linter configuration, rendered DocC, or behavior in Claude Code and Cursor. CLI installation validates packaging, not host reasoning. Swift examples and scripts were unchanged; release CI runs the existing Swift checks. No skills.sh indexing claim is made.

## Local Raw Evidence Index

Raw artifacts remain outside the repository:

- `/tmp/swift-comments-review-evaluation.md`: actual evaluator responses.
- `/tmp/swift-comments-review-validation.md`: earlier candidate hashes and per-case grading.
- `/tmp/swift-comments-release.LsXZp2/install-local.log`: CLI installation output.
- `/tmp/swift-comments-release.LsXZp2/install-local/`: installed package snapshot.

## Candidate SHA-256

| File | SHA-256 |
| --- | --- |
| skills/swift-comments-that-matter/SKILL.md | dc3e15e971e02ad826ab63c5820293f5e3a511217e601777bd9486385aff5839 |
| tests/skill-review/cases.md | 07206fae7554d7d7cd9149a5002a2237a8c8b201e2a7e3213568b70679acd95a |
| tests/skill-review/README.md | 71b8414564c327da81ceb23bbd495b90a8e3e2b97fc7e9a1c728abed779e61fc |
