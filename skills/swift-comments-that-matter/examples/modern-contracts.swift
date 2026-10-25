import Foundation
import Observation

// Editorial examples: transport, file replacement, and diagnostic bridges below
// are stubs. Their domain contracts illustrate wording, not verified runtime
// guarantees. No benchmark or trace is bundled; measure before adopting claims.

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

    // 3) GOOD OUTCOME: the actor boundary already expresses isolation.
    // No additional UI consumer or hidden constraint is supplied in this example.
    func appendGoodComment(_ value: String) {
        appendNoComment(value)
    }

    // 4) BEST OUTCOME: omit redundant internal documentation.
    // Preserve a public API summary separately if this type becomes public.
    func appendBestComment(_ value: String) {
        appendNoComment(value)
    }
}

// MARK: - Single-Use Upload Ownership

struct UploadLease: ~Copyable {
    let id: UUID
}

struct UploadCoordinator {
    // 1) NO COMMENT
    func startNoComment(with lease: consuming UploadLease) async {
        await openConnection(for: lease)
    }

    // 2) BAD COMMENT
    /// This function uses the lease.
    func startBadComment(with lease: consuming UploadLease) async {
        await startNoComment(with: lease)
    }

    // 3) GOOD COMMENT
    /// Ownership: a retry must request a fresh lease; this lease identifies one upload attempt.
    func startGoodComment(with lease: consuming UploadLease) async {
        await startNoComment(with: lease)
    }

    // 4) BEST COMMENT
    /// Ownership: request a fresh lease for retries; the server contract assigns each ID to one upload attempt.
    /// Why: reusing an attempt ID can attach a retry to the previous server session.
    func startBestComment(with lease: consuming UploadLease) async {
        await startNoComment(with: lease)
    }

    private func openConnection(for lease: consuming UploadLease) async {
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
    /// Cancellation: shield only the swap-through-commit/rollback region; preparation remains cancellable.
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
    /// Lifetime: row-local state may reset when a lazy container eventually discards an off-screen row.
    mutating func restoreGoodComment(from expandedIDs: Set<UUID>) {
        restoreNoComment(from: expandedIDs)
    }

    // 4) BEST COMMENT
    /// Lifetime: `LazyVStack` may retain this off-screen row for several updates, then discard its local state while the feed item remains.
    /// Constraint: persist expansion by stable item ID; never depend on either immediate eviction or permanent retention.
    mutating func restoreBestComment(from expandedIDs: Set<UUID>) {
        restoreNoComment(from: expandedIDs)
    }
}

@MainActor
final class LazyPageLoader {
    private var loadedPages: Set<Int> = []

    // 1) NO COMMENT
    func rowAppearedNoComment(page: Int) async {
        guard loadedPages.insert(page).inserted else { return }
        await fetchPage(page)
    }

    // 2) BAD COMMENT
    /// Loads the page once when the row appears.
    func rowAppearedBadComment(page: Int) async {
        await rowAppearedNoComment(page: page)
    }

    // 3) GOOD COMMENT
    /// Constraint: treat appearance as repeatable and coalesce requests by page.
    func rowAppearedGoodComment(page: Int) async {
        await rowAppearedNoComment(page: page)
    }

    // 4) BEST COMMENT
    /// Constraint: lazy prefetch can evaluate a row before display, and `onAppear` can run again after reentry.
    /// Why: mandatory setup belongs outside this callback; page requests remain idempotent through stable page identity.
    func rowAppearedBestComment(page: Int) async {
        await rowAppearedNoComment(page: page)
    }

    private func fetchPage(_ page: Int) async {
        _ = page
    }
}

@MainActor
final class SearchViewModel {
    private var latestRequestID: UUID?
    private(set) var results: [String] = []

    // 1) NO COMMENT
    func searchNoComment(query: String) async {
        let requestID = UUID()
        latestRequestID = requestID
        let response = await fetchResults(query: query)
        guard !Task.isCancelled, latestRequestID == requestID else { return }
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
    /// Constraint: identify each request separately; an A → B → A query sequence must not let the first A overwrite the last A.
    func searchBestComment(query: String) async {
        await searchNoComment(query: query)
    }

    private func fetchResults(query: String) async -> [String] {
        [query]
    }
}

// MARK: - Throwing Task Result Ownership

struct ReportUploadCoordinator {
    // 1) NO COMMENT
    func startNoComment() -> Task<Void, Error> {
        Task { try await upload() }
    }

    // 2) BAD COMMENT
    /// Starts the upload in a task.
    func startBadComment() -> Task<Void, Error> {
        startNoComment()
    }

    // 3) GOOD COMMENT
    /// Ownership: the caller retains and awaits the returned upload task.
    func startGoodComment() -> Task<Void, Error> {
        startNoComment()
    }

    // 4) BEST COMMENT
    /// Ownership: transfer this task to the upload supervisor, which owns cancellation and must observe its throwing result.
    /// Risk: dropping the handle leaves retry state unchanged after a failed upload.
    func startBestComment() -> Task<Void, Error> {
        startNoComment()
    }

    private func upload() async throws {}
}

// MARK: - Observation Implicit Dependencies

@MainActor
@Observable
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
    /// Observation: when called inside observation tracking, this read registers `unreadCount` as a dependency.
    func titleGoodComment() -> String {
        titleNoComment()
    }

    // 4) BEST COMMENT
    /// Observation: keep the `unreadCount` read inside the tracked title calculation.
    /// Why: callers that track this calculation need unread-count changes to invalidate it, even though the count is not rendered in the title.
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

// MARK: - Stream Ordering, Buffering, And Performance Evidence

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
    /// Ordering: complete each outbound send before starting the next.
    func writeGoodComment(_ messages: AsyncStream<String>) async {
        await writeNoComment(messages)
    }

    // 4) BEST COMMENT
    /// Ordering: this consumer sends sequentially; producer buffering and backpressure are separate contracts.
    /// Lifetime: normal stream completion drains buffered messages. Callers requiring discard-on-cancel need a separate cancellation policy.
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
    /// Performance: if a measured 10k-item fixture exceeds the interaction budget, callers should move decoding off the main actor.
    /// Evidence: replace this illustrative condition with the actual benchmark and budget before adopting it in a project.
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
    /// Compatibility: keep the diagnostic exception scoped to this legacy selector bridge and put its immediate justification in `@diagnose(reason:)`.
    /// Constraint: remove the exception once plugins expose typed entrypoints; widening it can hide unrelated diagnostics.
    func bridgeBestComment(_ selectorName: String) {
        bridgeNoComment(selectorName)
    }

    private func performSelector(named selectorName: String) {
        _ = selectorName
    }
}
