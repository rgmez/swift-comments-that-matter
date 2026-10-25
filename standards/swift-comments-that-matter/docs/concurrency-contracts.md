# Concurrency Contracts

Use this reference when a comment's accuracy depends on task lifetime, execution
context, or cancellation. It is a guide to documenting contracts, not a migration
checklist to apply to every comment review.

## Intentional Boundaries

Encode isolation and transfer rules where possible, then explain the intent that
must survive future edits. An explicit `Sendable`, `@MainActor`, or `nonisolated`
annotation can be worth keeping even when inferred. A useful comment explains
which consumer relies on that boundary; it does not describe the annotation.
Tests can verify an invariant without replacing the explanation of why it exists.

For `@unchecked Sendable` or `nonisolated(unsafe)`, do not claim compiler-enforced
safety. Identify the actual synchronization or access discipline, its coverage,
and the verification available. If these are unknown, use `needs-evidence`.

Apple explicitly discusses deliberate annotations and their rationale in
[Swift Group Lab, 19:48](https://developer.apple.com/videos/play/wwdc2026/8001/?time=1188).

## Execution Context Is A Contract

Before asserting where an async function runs, inspect its annotations, module
default isolation, language mode, and relevant upcoming-feature settings such as
`NonisolatedNonsendingByDefault`. `async` alone does not mean background execution;
`nonisolated` alone is not a portable promise of an executor hop across settings.

Comment a non-obvious dependency on the chosen isolation or scheduling boundary,
not an assumed thread number. Prefer ordering and actor guarantees over incidental
thread behavior. If the configuration is unavailable, report that limitation.

Apple explains the change toward caller-context execution in
[Swift Group Lab, 33:39](https://developer.apple.com/videos/play/wwdc2026/8001/?time=2019).

## Task Ownership And Cancellation

For unstructured work, identify who observes failures and who owns cancellation
and teardown. Dropping a task handle does not stop its work. Avoid calling every
`Task` a child task: an unstructured `Task` is not a structured child whose
lifetime and cancellation are bounded by a task group.

Cancellation is cooperative. Calling `cancel()` does not prove that a response
cannot update state. An operation that ignores cancellation, or a discarded
`CancellationError`, can still reach publication. Document the stale-result
policy and enforce it before mutating state; see
[concurrency.swift](../examples/concurrency.swift).

Reference: [Task cancellation](https://developer.apple.com/documentation/swift/task/cancel()).

## Cleanup Under Cancellation

Async cleanup can itself observe cancellation and return before restoring the
resource's required state. A `defer` containing `await` establishes when cleanup
is awaited; it does not by itself make cleanup cancellation-resistant.

When a shield is supported and justified, keep it around only the cleanup or
commit/rollback region that must finish. Explain the resource, the consistency
boundary, and what an early exit would leave behind. A shield masks cancellation
observation inside its scope; it does not make writes atomic, prevent other
errors, or guarantee successful recovery. Its scope is not automatically inherited
as a shield by child tasks.

[async-cleanup.swift](../examples/async-cleanup.swift) uses an in-memory resource
model to show awaited cleanup after cancellation. It does not implement durable
file replacement or prove rollback. The example requires a Swift 6.4 compiler
and the platform availability declared on its types; skip it on older runtimes
rather than substituting unstructured cleanup and claiming the same guarantee.

References:
[What’s new in Swift, 6:26](https://developer.apple.com/videos/play/wwdc2026/262/?time=386),
[cancellation shields](https://developer.apple.com/documentation/swift/withtaskcancellationshield%28operation%3A%29-2lzl8).

## SwiftUI And Observation

- Treat appearance as repeatable and lazy eviction timing as unspecified. Keep
  persistent domain state outside row-local state when it must survive eviction.
- Identify each request when query text can repeat; A → B → A must not allow the
  first A to publish as the last A.
- Comment a dependency read when its purpose is to register observation within a
  tracked calculation. An ordinary property read outside tracking is insufficient.
- For time-sensitive UI changes, preserve required synchronous ordering before
  starting asynchronous work instead of claiming a `Task` starts immediately.

References:
[Lazy stacks and scrolling](https://developer.apple.com/videos/play/wwdc2026/321/),
[Explore concurrency in SwiftUI, 17:07](https://developer.apple.com/videos/play/wwdc2025/266/?time=1027).
