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
    private let load: @Sendable () async throws -> [String]
    private(set) var items: [String] = []

    init(load: @escaping @Sendable () async throws -> [String] = {
        try await Task.sleep(for: .milliseconds(60))
        return ["A", "B", "C"]
    }) {
        self.load = load
    }

    // 1) NO COMMENT
    @discardableResult
    func onAppearNoComment() -> Task<Void, Never> {
        loadTask?.cancel()
        let task = Task { [weak self, load] in
            do {
                let response = try await load()
                guard !Task.isCancelled else { return }
                self?.items = response
            } catch {
                return
            }
        }
        loadTask = task
        return task
    }

    // 2) BAD COMMENT
    /// This method loads data when the view appears.
    @discardableResult
    func onAppearBadComment() -> Task<Void, Never> {
        onAppearNoComment()
    }

    // 3) GOOD COMMENT
    /// Ignores a cancelled load's response even when the loader completes normally.
    @discardableResult
    func onAppearGoodComment() -> Task<Void, Never> {
        onAppearNoComment()
    }

    // 4) BEST COMMENT
    /// Concurrency: view re-appear events can arrive faster than network completion.
    /// Constraint: cancellation must prevent publication even if the transport ignores it; failed loads preserve the last successful items.
    @discardableResult
    func onAppearBestComment() -> Task<Void, Never> {
        onAppearNoComment()
    }

    func cancelLoad() {
        loadTask?.cancel()
    }
}
