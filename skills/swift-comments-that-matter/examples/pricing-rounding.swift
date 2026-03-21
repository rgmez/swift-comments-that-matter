import Foundation

// MARK: - Pricing And Currency Rounding Constraints

final class PaymentAmountCalculator {
    private let currencyScale: Int16 = 2

    // 1) NO COMMENT
    func amountNoComment(subtotal: Decimal, tax: Decimal, discount: Decimal) -> Decimal {
        let raw = subtotal + tax - discount
        return rounded(raw, scale: currencyScale)
    }

    // 2) BAD COMMENT
    /// This function calculates the final payment amount.
    func amountBadComment(subtotal: Decimal, tax: Decimal, discount: Decimal) -> Decimal {
        amountNoComment(subtotal: subtotal, tax: tax, discount: discount)
    }

    // 3) GOOD COMMENT
    /// Rounds the final amount once at currency scale to avoid drift from intermediate rounding.
    func amountGoodComment(subtotal: Decimal, tax: Decimal, discount: Decimal) -> Decimal {
        amountNoComment(subtotal: subtotal, tax: tax, discount: discount)
    }

    // 4) BEST COMMENT
    /// Constraint: compute using full precision and round only once at provider currency scale.
    /// Invariant: persisted order total must match captured amount exactly to the cent.
    /// Why: re-rounding subtotal, tax, and discount independently can introduce a 1-cent drift that breaks settlement reconciliation.
    func amountBestComment(subtotal: Decimal, tax: Decimal, discount: Decimal) -> Decimal {
        amountNoComment(subtotal: subtotal, tax: tax, discount: discount)
    }

    private func rounded(_ value: Decimal, scale: Int16) -> Decimal {
        var value = value
        var result = Decimal()
        NSDecimalRound(&result, &value, Int(scale), .plain)
        return result
    }
}
