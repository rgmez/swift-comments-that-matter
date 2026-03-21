# Before / After Snippets

Reusable snippets for social posts, release notes, and replies.

## README Hero Example

Before:

```swift
/// Fetches the user profile
func fetchUserProfile() async throws -> User {
    try await api.getUser()
}
```

After:

```swift
/// Fetches the user profile.
///
/// - Important:
///   Not idempotent - triggers a network request each time.
///
/// - Side Effects:
///   Emits analytics event `profile_requested`.
///
/// - Why:
///   Used to track user engagement when entering the profile screen.
func fetchUserProfile() async throws -> User {
    try await api.getUser()
}
```

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
