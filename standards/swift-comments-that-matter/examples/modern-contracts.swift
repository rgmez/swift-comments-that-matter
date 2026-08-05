import Foundation

// MARK: - Compiler Contract Over Prose

@MainActor
final class MainActorStore {
    private var values: [String] = []

    // 1) NO COMMENT (clean but incomplete)
    func appendNoComment(_ value: String) {
        values.append(value)
    }

    // 2) BAD COMMENT (anti-pattern)
    /// This method is not thread-safe.
    func appendBadComment(_ value: String) {
        appendNoComment(value)
    }

    // 3) GOOD COMMENT (useful)
    /// Isolation: mutations must stay on the main actor because SwiftUI reads `values` during view updates.
    func appendGoodComment(_ value: String) {
        appendNoComment(value)
    }

    // 4) BEST COMMENT (intent + constraint + reasoning)
    /// Isolation: keep writes on the main actor; SwiftUI observes `values` during body evaluation and expects UI state to change on that executor.
    /// Why: a prose "not thread-safe" warning is weaker than the `@MainActor` boundary and should not be the source of truth for this contract.
    func appendBestComment(_ value: String) {
        appendNoComment(value)
    }
}

// MARK: - Ownership And Borrowed Lifetime

struct UploadLease {
    let id: UUID
}

struct UploadCoordinator {
    // 1) NO COMMENT
    func startNoComment(with lease: UploadLease) async {
        await openConnection(for: lease)
    }

    // 2) BAD COMMENT
    /// This function uses the lease.
    func startBadComment(with lease: UploadLease) async {
        await startNoComment(with: lease)
    }

    // 3) GOOD COMMENT
    /// Ownership: the coordinator owns the upload lease until the connection is closed.
    func startGoodComment(with lease: UploadLease) async {
        await startNoComment(with: lease)
    }

    // 4) BEST COMMENT
    /// Ownership: treat the lease as consumed by the upload session; do not share it with retry paths after `openConnection` starts.
    /// Lifetime: the lease remains valid only until the server closes the stream or the task is cancelled.
    func startBestComment(with lease: UploadLease) async {
        await startNoComment(with: lease)
    }

    private func openConnection(for lease: UploadLease) async {
        _ = lease
    }
}

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

// MARK: - Compatibility And Diagnostic Exceptions

struct LegacyLayoutAdapter {
    let usesLegacyObservationFallback: Bool

    // 1) NO COMMENT
    func invalidateNoComment() {
        if usesLegacyObservationFallback {
            invalidateManually()
        }
    }

    // 2) BAD COMMENT
    /// Temporary workaround for old systems.
    func invalidateBadComment() {
        invalidateNoComment()
    }

    // 3) GOOD COMMENT
    /// Compatibility: keep manual invalidation while legacy Observation fallback is enabled.
    func invalidateGoodComment() {
        invalidateNoComment()
    }

    // 4) BEST COMMENT
    /// Compatibility: manual invalidation exists only for the legacy Observation fallback.
    /// Constraint: remove this path with the fallback flag; until then, deleting it leaves UIKit/AppKit adapters with stale tracked reads.
    func invalidateBestComment() {
        invalidateNoComment()
    }

    private func invalidateManually() {}
}

struct DiagnosticException {
    // 1) NO COMMENT
    func bridgeNoComment(_ selectorName: String) {
        performSelector(named: selectorName)
    }

    // 2) BAD COMMENT
    /// Ignore the diagnostic here.
    func bridgeBadComment(_ selectorName: String) {
        bridgeNoComment(selectorName)
    }

    // 3) GOOD COMMENT
    /// Compatibility: dynamic selectors are required for the legacy plugin bridge.
    func bridgeGoodComment(_ selectorName: String) {
        bridgeNoComment(selectorName)
    }

    // 4) BEST COMMENT
    /// Compatibility: dynamic selector lookup is limited to the legacy plugin bridge.
    /// Constraint: keep the diagnostic exception scoped to this adapter and remove it once plugins expose typed entrypoints.
    func bridgeBestComment(_ selectorName: String) {
        bridgeNoComment(selectorName)
    }

    private func performSelector(named selectorName: String) {
        _ = selectorName
    }
}
