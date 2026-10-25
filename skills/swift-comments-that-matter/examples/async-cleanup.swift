// In-memory resource-lifetime example, not a durable file or database transaction.
// Older compilers exclude this scenario; the runtime must also satisfy availability.
#if compiler(>=6.4)
@available(macOS 27.0, iOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *)
actor ExportSession {
    private(set) var isClosed = false

    func close() async {
        guard !Task.isCancelled else { return }
        await Task.yield()
        isClosed = true
    }
}

@available(macOS 27.0, iOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *)
struct ExportWriter {
    // 1) NO COMMENT
    nonisolated(nonsending) func writeNoComment(
        session: ExportSession,
        operation: () async throws -> Void
    ) async throws {
        defer {
            await withTaskCancellationShield {
                await session.close()
            }
        }
        try Task.checkCancellation()
        try await operation()
    }

    // 2) BAD COMMENT
    /// Uses async defer and a cancellation shield.
    nonisolated(nonsending) func writeBadComment(
        session: ExportSession,
        operation: () async throws -> Void
    ) async throws {
        try await writeNoComment(session: session, operation: operation)
    }

    // 3) GOOD COMMENT
    /// Lifetime: the session is closed before this operation returns or throws.
    nonisolated(nonsending) func writeGoodComment(
        session: ExportSession,
        operation: () async throws -> Void
    ) async throws {
        try await writeNoComment(session: session, operation: operation)
    }

    // 4) BEST COMMENT
    /// Cancellation: keep the session's close operation shielded; cancellation must not skip releasing the export resource.
    /// Lifetime: callers may release the session after this operation returns or throws because cleanup has already been awaited.
    nonisolated(nonsending) func writeBestComment(
        session: ExportSession,
        operation: () async throws -> Void
    ) async throws {
        try await writeNoComment(session: session, operation: operation)
    }
}
#endif
