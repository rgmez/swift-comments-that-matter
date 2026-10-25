## Summary

- Preserves useful symbol documentation and the rationale behind deliberate compiler-visible contracts.
- Makes comment reviews concise and evidence-based, including `needs-evidence` for unresolved claims and four-tier alternatives only when requested.
- Corrects cancellation and shared-download examples, adds executable regressions, and expands Apple-backed guidance for isolation, cleanup, and DocC.

## Why this release

The previous guidance could treat an API summary as redundant, expand a
comment-only review into a refactor, or delete a restriction whose supporting
context was unavailable. The portable entrypoint now provides a focused workflow
with conditional references, preserves deliberate contract rationale, and separates
missing evidence from demonstrably incorrect claims.

The examples now prevent cancelled loads from publishing stale UI state, serialize
shared-download bookkeeping in an actor, and protect replacement tasks from retired
cleanup. Other improvements cover request identity in A-to-B-to-A searches,
non-copyable upload leases, observable dependencies, and stream ordering versus
producer backpressure. Stub implementations and hypothetical evidence are labeled.

Apple-backed references cover executor configuration, awaited cleanup under
cancellation, documentation extension files for generated symbols, and proportional
Quick Help / Documentation Preview / Build Documentation checks. The research report
includes source links and corrects the attribution of the short-shield recommendation.

## Compatibility notes

- No breaking changes to install paths, adapter entrypoints, standard paths, or portable package layout.
- Ordinary reviews return a recommendation and final rewrite or deletion; request `no/bad/good/best` explicitly for comparison or teaching.
- Use `needs-evidence` and preserve uncertain comments provisionally rather than treating missing context as proof of falsehood.
- Refactor-first remains a decision rule; code changes must fit the authorized scope.
- `DownloadManager` is now an actor returning a shared `Task<Data, Error>`; callers await its result and own its cancellation. Examples are guidance, not a shipped framework API.
- The async-cleanup example requires Swift 6.4 and macOS 27 / corresponding platform availability. Older compilers exclude it, and older systems omit it from the behavior executable to avoid new runtime symbols.

## Test plan

- [x] Validate local Markdown links and adapter references
- [x] Validate mirrored docs/examples remain in sync
- [x] Run markdownlint and `git diff --check`
- [x] Validate the portable skill with `quick_validate.py`
- [x] Type-check all standalone examples in Swift 6 language mode with Swift 6.4
- [x] Run deterministic regressions for cancelled/failed UI publication, download sharing/replacement/retry, and normal stream completion
- [x] Forward-test the skill independently on summaries, missing evidence, DocC extensions, and executor assumptions
- [x] Execute shielded async-cleanup checks on macOS 27 — [successful CI run](https://github.com/rgmez/swift-comments-that-matter/actions/runs/40178720071/job/121124959108)

Type-checking does not verify the runtime contracts of stub transports, durable
file replacement, or hypothetical benchmarks. No consuming DocC project was
built; rendered checks belong to a project with resolvable documentation symbols.

## Post-release runtime verification

On October 25, 2026, the required cleanup job passed on macOS 27.0.1 (26A434),
Xcode 27.1 (27A9275), and Swift 6.4. The tested cleanup example and assertions
match tag `v1.3.0`. The job verified that cleanup completes before cancellation
or operation failure returns, and reported no skipped cleanup scenario.

[Execution log](https://github.com/rgmez/swift-comments-that-matter/actions/runs/40178720071/job/121124959108).
