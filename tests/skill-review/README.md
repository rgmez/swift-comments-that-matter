# Review Behavior Evaluation

These cases evaluate review decisions, not Swift execution or exact phrasing.
They complement the example compilation and runtime checks. They are a manual
agent evaluation, not an automated CI job.

## Run

Give a fresh evaluator the skill at
[SKILL.md](../../skills/swift-comments-that-matter/SKILL.md) and
[cases.md](cases.md). Ask it to answer each request using that skill and save
its actual responses outside the working tree. Do not pass this rubric, intended
answers, or a proposed fix to the evaluator. It may read supporting skill
references as needed, but should not inspect this rubric or previous results.
When practical, run each request in a fresh context to avoid cross-case hints;
record when one session handles the whole batch.

Grade the actual responses against the criteria below. Judge decisions and
proposed edits, not wording, heading names, or exact classification tokens when
an equivalent explanation is clear. A self-reported pass is not evidence.

## Acceptance Criteria

| Case | Required behavior | Failure examples |
| --- | --- | --- |
| 1. Symbol summary | Preserve a useful summary, including ordering and duplicate behavior. A no-change response is valid. | Delete it because the signature, body, or tests already express the behavior; invent hidden risks. |
| 2. External restriction | Preserve the cap comment provisionally, identify the unresolved provider limit and the documentation or owner needed to confirm it. | Delete it for lack of local evidence; assert the provider limit is verified; invent an issue or provider version. |
| 3. Redundant narration | Recommend or show deletion of the redundant comment, preserving the implementation. | Add a speculative invariant or change Swift behavior. |
| 4. Tooling and notices | Preserve both notices, lint directives, and generator markers with their placement and scope. Remove the redundant method narration. | Delete or relocate protected lines because they lack explanatory value; claim tooling validation without configuration. |
| 5. Contract mismatch | Identify the empty-array subscript trap as a code defect against the supplied contract. Keep the intended documentation and report the code fix separately without applying it. | Rewrite the documentation to legitimize the trap; silently change Swift code; claim the contract is implemented. |
| 6. Ordinary review | Report the redundant comment deletion. If shortening the generic symbol summary, preserve its useful behavior and present it as editorial. Omit an unchanged-comment inventory and four-tier alternatives. | Report the generic opening as a correctness failure; remove useful API documentation; list every unchanged comment. |
| 7. Complete inventory | Classify both comments: keep the useful symbol summary and delete redundant narration, with reasons. | Omit the kept summary despite the explicit inventory request; force four-tier teaching output. |

All applicable requirements must hold for a case to pass. Record ambiguous
responses as inconclusive and inspect them rather than counting them as passes.
After a correction, repeat affected cases; broaden only if the change alters
shared decision rules.

## Evidence

Record the candidate Git revision and working-tree changes, skill path, date,
evaluator identity/model when known, whether contexts were independent, and
per-case results with response references. Keep raw transcripts outside the
repository or in a local ignored directory; report limitations such as missing
live tooling or rendered DocC validation. Do not describe fixture-based decisions
as verification of a real provider, generator, or application.
