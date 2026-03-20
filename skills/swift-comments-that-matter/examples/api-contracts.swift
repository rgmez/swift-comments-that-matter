import Foundation

// MARK: - Public API Contracts In Frameworks

public struct SDKClient {
    public init() {}

    // 1) NO COMMENT
    public func fetchProfileNoComment(userID: String) async throws -> Data {
        if userID.isEmpty { throw ContractError.invalidID }
        return Data("profile".utf8)
    }

    // 2) BAD COMMENT
    /// This function fetches a profile from backend.
    public func fetchProfileBadComment(userID: String) async throws -> Data {
        try await fetchProfileNoComment(userID: userID)
    }

    // 3) GOOD COMMENT
    /// Contract: throws `invalidID` when `userID` is empty, instead of issuing a network call.
    public func fetchProfileGoodComment(userID: String) async throws -> Data {
        try await fetchProfileNoComment(userID: userID)
    }

    // 4) BEST COMMENT
    /// Contract: validates `userID` locally and fails fast with `invalidID`.
    /// Constraint: empty IDs must never hit transport to preserve server-side error budgets.
    /// Why: consumers depend on this preflight behavior for predictable retry logic.
    public func fetchProfileBestComment(userID: String) async throws -> Data {
        try await fetchProfileNoComment(userID: userID)
    }
}

public enum ContractError: Error {
    case invalidID
}

// MARK: - Analytics Side Effects

public final class PurchaseTracker {
    public init() {}

    // 1) NO COMMENT
    public func recordNoComment(orderID: String, amount: Decimal) {
        if amount > 0 {
            sendAnalyticsEvent(orderID: orderID, amount: amount)
        }
    }

    // 2) BAD COMMENT
    /// This method records analytics for a purchase.
    public func recordBadComment(orderID: String, amount: Decimal) {
        recordNoComment(orderID: orderID, amount: amount)
    }

    // 3) GOOD COMMENT
    /// Emits analytics only for positive captures to keep revenue dashboards consistent.
    public func recordGoodComment(orderID: String, amount: Decimal) {
        recordNoComment(orderID: orderID, amount: amount)
    }

    // 4) BEST COMMENT
    /// Side Effects: emits an external analytics event consumed by finance reports.
    /// Constraint: do not call from compensation/refund paths; they use a different event schema.
    /// Why: mixing event types here causes double-counted revenue in downstream aggregation.
    public func recordBestComment(orderID: String, amount: Decimal) {
        recordNoComment(orderID: orderID, amount: amount)
    }

    private func sendAnalyticsEvent(orderID: String, amount: Decimal) {
        _ = (orderID, amount)
    }
}
