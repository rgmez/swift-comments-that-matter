# Examples Index

Quick navigation for production-style comment rewrites (`no`, `bad`, `good`, `best`):

- `concurrency.swift`
  - token refresh coalescing
  - cancellation-aware publication with a loader that may ignore cancellation
- `invariants.swift`
  - actor-isolated download deduplication and identity-safe completion cleanup
  - cache eviction assumptions
- `api-contracts.swift`
  - public SDK contract guarantees
  - analytics side-effect boundaries
- `better-comments.swift`
  - background scheduling constraints
  - cache policy assumptions
- `pricing-rounding.swift`
  - currency rounding constraints
  - settlement reconciliation safety
- `modern-contracts.swift`
  - compiler-enforced isolation with no redundant internal comment
  - single-use upload ownership and retry boundaries
  - cancellation point-of-no-return
  - narrowly scoped cancellation shields
  - SwiftUI lazy retention/eviction, prefetch, `onAppear`, and `.task(id:)` reentry
  - throwing-task result ownership
  - Observation implicit dependency reads
  - generated schema source-of-truth
  - sequential stream sending versus producer backpressure, and illustrative performance evidence
  - compatibility fallbacks and diagnostic exceptions
- `async-cleanup.swift`
  - awaited cleanup under cancellation, using an in-memory resource model
  - requires Swift 6.4 and macOS 27 / corresponding platform availability
- `bad-comments.swift`
  - anti-pattern baselines for rewrite drills
