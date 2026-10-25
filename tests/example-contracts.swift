import Foundation

private enum ProbeError: Error {
    case expected
}

// Continuations control completion order without network requests or timing sleeps.
private actor ControlledRequests<Value: Sendable> {
    private(set) var requestCount = 0
    private var pending: [Int: CheckedContinuation<Value, Error>] = [:]
    private var arrivals: [Int: CheckedContinuation<Void, Never>] = [:]

    func load() async throws -> Value {
        try await withCheckedThrowingContinuation { continuation in
            let id = requestCount
            requestCount += 1
            pending[id] = continuation
            arrivals.removeValue(forKey: id)?.resume()
        }
    }

    func waitUntilRequested(_ id: Int) async {
        if requestCount > id { return }
        await withCheckedContinuation { arrivals[id] = $0 }
    }

    func succeed(_ id: Int, with value: Value) {
        guard let continuation = pending.removeValue(forKey: id) else {
            preconditionFailure("Request \(id) is not pending")
        }
        continuation.resume(returning: value)
    }

    func fail(_ id: Int) {
        guard let continuation = pending.removeValue(forKey: id) else {
            preconditionFailure("Request \(id) is not pending")
        }
        continuation.resume(throwing: ProbeError.expected)
    }
}

@main
private struct ExampleContracts {
    @MainActor
    static func main() async throws {
        await verifyFeedPublication()
        try await verifyDownloads()
        await verifyStreamCompletion()
        #if compiler(>=6.4) && CAN_RUN_ASYNC_CLEANUP
        if #available(macOS 27.0, *) {
            try await verifyAsyncCleanup()
        } else {
            print("SKIP: shielded async cleanup requires macOS 27; example is type-checked")
        }
        #else
        print("SKIP: shielded async cleanup requires Swift 6.4 and a macOS 27 runtime")
        #endif
        print("Example behavior checks passed")
    }

    @MainActor
    private static func verifyFeedPublication() async {
        let requests = ControlledRequests<[String]>()
        let model = FeedViewModel { try await requests.load() }
        let old = model.onAppearBestComment()
        await requests.waitUntilRequested(0)
        let latest = model.onAppearBestComment()
        await requests.waitUntilRequested(1)

        await requests.succeed(1, with: ["latest"])
        await latest.value
        precondition(model.items == ["latest"])
        await requests.succeed(0, with: ["obsolete"])
        await old.value
        precondition(old.isCancelled)
        precondition(model.items == ["latest"], "Cancelled transport must not publish stale data")

        let cancelled = model.onAppearBestComment()
        await requests.waitUntilRequested(2)
        model.cancelLoad()
        await requests.succeed(2, with: ["cancelled"])
        await cancelled.value
        precondition(model.items == ["latest"], "Cancelling the current load must prevent publication")

        let failed = model.onAppearBestComment()
        await requests.waitUntilRequested(3)
        await requests.fail(3)
        await failed.value
        precondition(model.items == ["latest"], "Failure must preserve the last successful state")
        print("PASS: cancelled and failed loads preserve current UI state")
    }

    private static func verifyDownloads() async throws {
        let requests = ControlledRequests<Data>()
        let manager = DownloadManager { _ in try await requests.load() }
        let url = URL(string: "https://example.invalid/export")!
        let first = await manager.startBestComment(fileKey: "export", url: url)
        await requests.waitUntilRequested(0)
        let shared = await manager.startBestComment(fileKey: "export", url: url)
        let firstPayload = Data("first".utf8)
        await requests.succeed(0, with: firstPayload)
        let firstValue = try await first.value
        let sharedValue = try await shared.value
        let firstCount = await requests.requestCount
        precondition(firstValue == firstPayload && sharedValue == firstPayload && firstCount == 1)

        let retired = await manager.startBestComment(fileKey: "export", url: url)
        await requests.waitUntilRequested(1)
        retired.cancel()
        let replacement = await manager.startBestComment(fileKey: "export", url: url)
        await requests.waitUntilRequested(2)
        await requests.succeed(1, with: Data("retired".utf8))
        _ = try await retired.value

        let replacementShared = await manager.startBestComment(fileKey: "export", url: url)
        let newPayload = Data("replacement".utf8)
        await requests.succeed(2, with: newPayload)
        let replacementValue = try await replacement.value
        let replacementSharedValue = try await replacementShared.value
        let replacementCount = await requests.requestCount
        precondition(replacementValue == newPayload && replacementSharedValue == newPayload)
        precondition(replacementCount == 3, "Retired cleanup must not remove a replacement entry")

        let failure = await manager.startBestComment(fileKey: "export", url: url)
        await requests.waitUntilRequested(3)
        await requests.fail(3)
        do {
            _ = try await failure.value
            preconditionFailure("Expected a failed download")
        } catch ProbeError.expected {}

        let retry = await manager.startBestComment(fileKey: "export", url: url)
        await requests.waitUntilRequested(4)
        await requests.succeed(4, with: newPayload)
        let retryValue = try await retry.value
        precondition(retryValue == newPayload, "A failed entry must allow a fresh request")
        print("PASS: download sharing, completion, cancellation replacement, and retry")
    }

    private static func verifyStreamCompletion() async {
        let pair = AsyncStream<Int>.makeStream()
        pair.continuation.yield(1)
        pair.continuation.yield(2)
        pair.continuation.finish()
        var values: [Int] = []
        for await value in pair.stream { values.append(value) }
        precondition(values == [1, 2], "Normal completion drains buffered stream values")
        print("PASS: normal AsyncStream completion drains buffered values")
    }

    #if compiler(>=6.4) && CAN_RUN_ASYNC_CLEANUP
    @available(macOS 27.0, *)
    @MainActor
    private static func verifyAsyncCleanup() async throws {
        let cancelledSession = ExportSession()
        let cancelled = Task {
            try await ExportWriter().writeBestComment(session: cancelledSession) {
                preconditionFailure("Cancelled work must not start")
            }
        }
        cancelled.cancel()
        do {
            try await cancelled.value
            preconditionFailure("Expected cancellation")
        } catch is CancellationError {}
        let closedAfterCancellation = await cancelledSession.isClosed
        precondition(closedAfterCancellation, "Cleanup must finish before cancellation returns")

        let failedSession = ExportSession()
        do {
            try await ExportWriter().writeBestComment(session: failedSession) {
                throw ProbeError.expected
            }
            preconditionFailure("Expected operation failure")
        } catch ProbeError.expected {}
        let closedAfterFailure = await failedSession.isClosed
        precondition(closedAfterFailure, "Cleanup must finish before failure returns")
        print("PASS: shielded cleanup is awaited after cancellation and failure")
    }
    #endif
}
