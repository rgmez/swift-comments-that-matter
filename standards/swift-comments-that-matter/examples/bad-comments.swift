import Foundation

// Intentionally bad comment style examples.
// These reflect common anti-patterns and should NOT be copied.

final class PaymentAuthorizer {
    // 1) NO COMMENT
    func authorizeNoComment(orderID: String, amount: Decimal) -> Bool {
        amount > 0 && !orderID.isEmpty
    }

    // 2) BAD COMMENT
    /// This function authorizes a payment for an order.
    func authorizeBadComment(orderID: String, amount: Decimal) -> Bool {
        authorizeNoComment(orderID: orderID, amount: amount)
    }

    // 3) GOOD COMMENT
    /// Accepts only positive amounts and non-empty order IDs before provider authorization.
    func authorizeGoodComment(orderID: String, amount: Decimal) -> Bool {
        authorizeNoComment(orderID: orderID, amount: amount)
    }

    // 4) BEST COMMENT
    /// Constraint: local preflight must reject invalid payloads before touching provider APIs.
    /// Why: provider retries on malformed payloads can reserve funds without a reconcilable order record.
    func authorizeBestComment(orderID: String, amount: Decimal) -> Bool {
        authorizeNoComment(orderID: orderID, amount: amount)
    }
}

final class SessionStore {
    private(set) var token: String?

    // 1) NO COMMENT
    func saveNoComment(_ token: String) {
        self.token = token
    }

    // 2) BAD COMMENT
    /// This method stores the token.
    func saveBadComment(_ token: String) {
        saveNoComment(token)
    }

    // 3) GOOD COMMENT
    /// Replaces the in-memory token immediately after refresh succeeds.
    func saveGoodComment(_ token: String) {
        saveNoComment(token)
    }

    // 4) BEST COMMENT
    /// Side Effects: overwrites the active session token used by subsequent authenticated calls.
    /// Assumption: caller has already persisted the same token to secure storage.
    func saveBestComment(_ token: String) {
        saveNoComment(token)
    }
}
