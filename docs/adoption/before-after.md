# Before / After Snippets

Reusable snippets for social posts, release notes, and replies.

## Concurrency (Token Refresh)

Before:

```swift
/// This function refreshes a token and returns it.
```

After:

```swift
/// Concurrency: allows at most one refresh task at a time.
/// Invariant: all concurrent callers await the same task instance.
/// Why: parallel refreshes can invalidate token chains out of order.
```

## Pricing (Rounding)

Before:

```swift
/// This function calculates the final payment amount.
```

After:

```swift
/// Constraint: round once at provider currency scale before capture.
/// Invariant: persisted total must match captured amount to the cent.
/// Why: intermediate re-rounding can create reconciliation drift.
```
