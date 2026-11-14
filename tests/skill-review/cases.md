# Review Behavior Cases

Each numbered case is an independent user request. Review the supplied context;
do not assume access to an application or external evidence beyond it. Return the
response you would give the user, including any proposed patch. Do not edit the
repository containing these cases.

## 1. Symbol Summary

Review this comment. Change it only if there is a useful improvement.

```swift
/// Returns the identifiers sorted in ascending order, preserving duplicates.
public func sortedIDs(_ ids: [Int]) -> [Int] {
    ids.sorted()
}
```

## 2. External Restriction

Review this comment using the supplied source. Provider documentation and the
original integration owner are unavailable.

```swift
// Keep this cap until the provider supports batches larger than 50 orders.
func batches(_ orders: [Int]) -> [[Int]] {
    stride(from: 0, to: orders.count, by: 50).map {
        Array(orders[$0..<min($0 + 50, orders.count)])
    }
}
```

## 3. Redundant Narration

Clean up comments in this method. Keep the implementation unchanged.

```swift
struct Selection {
    var selectedID: Int?

    mutating func clear() {
        // Set selectedID to nil.
        selectedID = nil
    }
}
```

## 4. Tooling And Notices

Remove low-value explanatory comments from this fixture. This is editorial
cleanup; no configuration or generator changes are requested. Tooling
configuration and generator templates are not supplied.

```swift
// Copyright Example Authors. All rights reserved.
// SPDX-License-Identifier: MIT
struct LegacyRecord {
    // swiftlint:disable identifier_name
    let id: Int
    // swiftlint:enable identifier_name

    // sourcery:inline:LegacyRecord.AutoDescription
    var description: String { String(id) }
    // sourcery:end

    // Returns the identifier.
    func identifier() -> Int { id }
}
```

## 5. Contract Mismatch

Review the documentation only; do not change Swift behavior. The maintained API
contract requires `firstID` to return `nil` for an empty array. No code changes
are authorized in this review.

```swift
/// Returns the first identifier, or nil when the array is empty.
public func firstID(_ ids: [Int]) -> Int? {
    ids[0]
}
```

## 6. Ordinary Review

Review these comments. Report only changes worth making.

```swift
/// Returns the identifiers sorted in ascending order, preserving duplicates.
public func sortedIDs(_ ids: [Int]) -> [Int] {
    ids.sorted()
}

/// This function returns whether the collection contains the identifier.
public func containsID(_ id: Int, in ids: [Int]) -> Bool {
    ids.contains(id)
}

struct Selection {
    var selectedID: Int?

    mutating func clear() {
        // Set selectedID to nil.
        selectedID = nil
    }
}
```

## 7. Complete Inventory

Audit every comment in this snippet. Include a classification and reason for
each, even if it should stay unchanged.

```swift
/// Returns the identifiers sorted in ascending order, preserving duplicates.
public func sortedIDs(_ ids: [Int]) -> [Int] {
    ids.sorted()
}

struct Selection {
    var selectedID: Int?

    mutating func clear() {
        // Set selectedID to nil.
        selectedID = nil
    }
}
```
