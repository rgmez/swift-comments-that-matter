import Foundation

// MARK: - Cancellation Point Of No Return

struct AtomicFileReplacer {
    let targetURL: URL
    let stagingURL: URL

    // 1) NO COMMENT (clean but incomplete)
    func commitNoComment() async throws {
        try await replaceStagedFile()
    }

    // 2) BAD COMMENT (anti-pattern)
    /// This function replaces the file and handles cancellation.
    func commitBadComment() async throws {
        try await commitNoComment()
    }

    // 3) GOOD COMMENT (useful)
    /// Cancellation: once file replacement begins, cleanup must finish before returning.
    func commitGoodComment() async throws {
        try await commitNoComment()
    }

    // 4) BEST COMMENT (intent + constraint + reasoning)
    /// Cancellation: after the staged file is swapped into place, cancellation is shielded until commit or rollback finishes.
    /// Invariant: callers must never observe a state where both the old and staged files are unrecoverable.
    /// Why: exiting between replacement and cleanup can leave neither version safe to restore.
    func commitBestComment() async throws {
        try await commitNoComment()
    }

    private func replaceStagedFile() async throws {
        _ = (targetURL, stagingURL)
    }
}

// MARK: - SwiftUI Lazy Lifetime And Reentry

struct FeedRowController {
    let id: UUID
    private(set) var isExpanded = false

    // 1) NO COMMENT
    mutating func restoreNoComment(from expandedIDs: Set<UUID>) {
        isExpanded = expandedIDs.contains(id)
    }

    // 2) BAD COMMENT
    /// This method restores expanded state.
    mutating func restoreBadComment(from expandedIDs: Set<UUID>) {
        restoreNoComment(from: expandedIDs)
    }

    // 3) GOOD COMMENT
    /// Lifetime: row-local state may reset when a lazy container discards an off-screen row.
    mutating func restoreGoodComment(from expandedIDs: Set<UUID>) {
        restoreNoComment(from: expandedIDs)
    }

    // 4) BEST COMMENT
    /// Lifetime: `LazyVStack` may discard this row while the item remains in the feed model.
    /// Constraint: persist expansion by stable item ID, not in row-local state, so scrolling away cannot lose domain state.
    mutating func restoreBestComment(from expandedIDs: Set<UUID>) {
        restoreNoComment(from: expandedIDs)
    }
}

@MainActor
final class SearchViewModel {
    private var latestQuery = ""
    private(set) var results: [String] = []

    // 1) NO COMMENT
    func searchNoComment(query: String) async {
        latestQuery = query
        let response = await fetchResults(query: query)
        guard latestQuery == query else { return }
        results = response
    }

    // 2) BAD COMMENT
    /// This method searches when the task changes.
    func searchBadComment(query: String) async {
        await searchNoComment(query: query)
    }

    // 3) GOOD COMMENT
    /// Cancellation: ignore stale completions from earlier `.task(id:)` runs.
    func searchGoodComment(query: String) async {
        await searchNoComment(query: query)
    }

    // 4) BEST COMMENT
    /// Cancellation: `.task(id:)` may restart before the previous search completes.
    /// Constraint: only the response matching `latestQuery` may mutate UI state, otherwise an older result can overwrite the visible query.
    func searchBestComment(query: String) async {
        await searchNoComment(query: query)
    }

    private func fetchResults(query: String) async -> [String] {
        [query]
    }
}

// MARK: - Observation Implicit Dependencies

@MainActor
final class BadgePresenter {
    var unreadCount = 0

    // 1) NO COMMENT
    func titleNoComment() -> String {
        _ = unreadCount
        return "Inbox"
    }

    // 2) BAD COMMENT
    /// This method returns the title.
    func titleBadComment() -> String {
        titleNoComment()
    }

    // 3) GOOD COMMENT
    /// Observation: the `unreadCount` read registers this title for invalidation.
    func titleGoodComment() -> String {
        titleNoComment()
    }

    // 4) BEST COMMENT
    /// Observation: keep the `unreadCount` read inside the tracked title calculation.
    /// Why: UIKit/AppKit observation only invalidates this adapter when the dependency is read during tracking, even though the value is not rendered directly.
    func titleBestComment() -> String {
        titleNoComment()
    }
}

// MARK: - Generated Schema Source Of Truth

struct OrdersClientWrapper {
    // 1) NO COMMENT
    func submitNoComment(orderID: String) async throws {
        try await send(orderID: orderID)
    }

    // 2) BAD COMMENT
    /// This method calls the generated orders client.
    func submitBadComment(orderID: String) async throws {
        try await submitNoComment(orderID: orderID)
    }

    // 3) GOOD COMMENT
    /// Generated: request and response contracts are owned by `orders.proto`.
    func submitGoodComment(orderID: String) async throws {
        try await submitNoComment(orderID: orderID)
    }

    // 4) BEST COMMENT
    /// Generated: field numbers in `orders.proto` are the compatibility contract and must not be reused.
    /// Constraint: update the schema and regenerate the client instead of patching generated Swift by hand.
    func submitBestComment(orderID: String) async throws {
        try await submitNoComment(orderID: orderID)
    }

    private func send(orderID: String) async throws {
        _ = orderID
    }
}

// MARK: - Streams, Backpressure, And Performance Evidence

struct MessageStreamWriter {
    // 1) NO COMMENT
    func writeNoComment(_ messages: AsyncStream<String>) async {
        for await message in messages {
            await send(message)
        }
    }

    // 2) BAD COMMENT
    /// This function writes messages to the stream.
    func writeBadComment(_ messages: AsyncStream<String>) async {
        await writeNoComment(messages)
    }

    // 3) GOOD COMMENT
    /// Backpressure: send each message only after the previous write is accepted.
    func writeGoodComment(_ messages: AsyncStream<String>) async {
        await writeNoComment(messages)
    }

    // 4) BEST COMMENT
    /// Backpressure: preserve server ordering by awaiting each outbound write before reading the next message.
    /// Cancellation: closing `messages` is the producer's cancellation signal; do not drain buffered UI events after the stream ends.
    func writeBestComment(_ messages: AsyncStream<String>) async {
        await writeNoComment(messages)
    }

    private func send(_ message: String) async {
        _ = message
    }
}

struct SearchDecoder {
    // 1) NO COMMENT
    func decodeNoComment(_ data: Data) throws -> [String] {
        try JSONDecoder().decode([String].self, from: data)
    }

    // 2) BAD COMMENT
    /// This function is optimized for performance.
    func decodeBadComment(_ data: Data) throws -> [String] {
        try decodeNoComment(data)
    }

    // 3) GOOD COMMENT
    /// Performance: keep large-result decoding off the main actor.
    func decodeGoodComment(_ data: Data) throws -> [String] {
        try decodeNoComment(data)
    }

    // 4) BEST COMMENT
    /// Performance: keep 10k-item decoding off the main actor; `SearchResults.trace` shows it otherwise exceeds the 100 ms interaction budget.
    /// Constraint: update the trace or remove this comment if the fixture size or interaction budget changes.
    func decodeBestComment(_ data: Data) throws -> [String] {
        try decodeNoComment(data)
    }
}
