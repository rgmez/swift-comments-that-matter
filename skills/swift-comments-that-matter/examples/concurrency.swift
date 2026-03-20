import Foundation

// MARK: - Token Refresh With Concurrency Risks

actor TokenRefresher {
    private var refreshTask: Task<String, Error>?
    private var cachedToken: String

    init(cachedToken: String) {
        self.cachedToken = cachedToken
    }

    // 1) NO COMMENT (clean but incomplete)
    func tokenNoComment() async throws -> String {
        if let refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> String in
            let token = try await fetchNewToken()
            cachedToken = token
            return token
        }
        refreshTask = task
        defer { refreshTask = nil }
        return try await task.value
    }

    // 2) BAD COMMENT (anti-pattern)
    /// This function refreshes a token and returns it.
    func tokenBadComment() async throws -> String {
        try await tokenNoComment()
    }

    // 3) GOOD COMMENT (useful)
    /// Coalesces parallel refresh requests so callers share one in-flight task.
    func tokenGoodComment() async throws -> String {
        try await tokenNoComment()
    }

    // 4) BEST COMMENT (intent + constraint + reasoning)
    /// Concurrency: allows at most one refresh task at a time.
    /// Invariant: all concurrent callers await the same task instance.
    /// Why: issuing parallel refreshes can invalidate token chains out of order and force logout on the next protected request.
    func tokenBestComment() async throws -> String {
        try await tokenNoComment()
    }

    private func fetchNewToken() async throws -> String {
        try await Task.sleep(for: .milliseconds(80))
        return UUID().uuidString
    }
}

// MARK: - SwiftUI Async Lifecycle Edge Case

@MainActor
final class FeedViewModel {
    private var loadTask: Task<Void, Never>?
    private(set) var items: [String] = []

    // 1) NO COMMENT
    func onAppearNoComment() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .milliseconds(60))
            items = ["A", "B", "C"]
        }
    }

    // 2) BAD COMMENT
    /// This method loads data when the view appears.
    func onAppearBadComment() {
        onAppearNoComment()
    }

    // 3) GOOD COMMENT
    /// Cancels any prior load task before starting a new one for the latest view appearance.
    func onAppearGoodComment() {
        onAppearNoComment()
    }

    // 4) BEST COMMENT
    /// Concurrency: view re-appear events can arrive faster than network completion.
    /// Constraint: keep only the most recent load task to avoid stale writes from older responses.
    /// Side Effects: replacing `items` is a UI state mutation and must remain on the main actor.
    func onAppearBestComment() {
        onAppearNoComment()
    }
}
