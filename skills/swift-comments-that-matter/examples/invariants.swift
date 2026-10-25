import Foundation

// MARK: - Download Manager Deduplication Invariant

actor DownloadManager {
    private struct Entry {
        let id: UUID
        let task: Task<Data, Error>
    }

    private var activeTasks: [String: Entry] = [:]
    private let fetch: @Sendable (URL) async throws -> Data

    init(fetch: @escaping @Sendable (URL) async throws -> Data = { url in
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }) {
        self.fetch = fetch
    }

    // 1) NO COMMENT
    func startNoComment(fileKey: String, url: URL) -> Task<Data, Error> {
        if let existing = activeTasks[fileKey], !existing.task.isCancelled {
            return existing.task
        }
        let id = UUID()
        let task = Task {
            defer {
                if activeTasks[fileKey]?.id == id {
                    activeTasks.removeValue(forKey: fileKey)
                }
            }
            return try await fetch(url)
        }
        activeTasks[fileKey] = Entry(id: id, task: task)
        return task
    }

    // 2) BAD COMMENT
    /// This function starts a download for the file.
    func startBadComment(fileKey: String, url: URL) -> Task<Data, Error> {
        startNoComment(fileKey: fileKey, url: url)
    }

    // 3) GOOD COMMENT
    /// Reuses the in-flight task for the same `fileKey` to avoid duplicate downloads.
    func startGoodComment(fileKey: String, url: URL) -> Task<Data, Error> {
        startNoComment(fileKey: fileKey, url: url)
    }

    // 4) BEST COMMENT
    /// Invariant: each key owns one reusable task; completion of a retired task must not remove its replacement.
    /// Ownership: callers observe the returned task's errors; cancelling the shared handle affects every caller using it.
    /// Constraint: a key identifies one resource URL, and a cancelled request may still finish if the transport ignores cancellation.
    func startBestComment(fileKey: String, url: URL) -> Task<Data, Error> {
        startNoComment(fileKey: fileKey, url: url)
    }
}

// MARK: - Cache Eviction Assumptions

final class ImageCache {
    private var store: [String: Data] = [:]
    private var lruOrder: [String] = []
    private let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
    }

    // 1) NO COMMENT
    func insertNoComment(_ data: Data, for key: String) {
        if store[key] == nil && store.count >= capacity, let victim = lruOrder.first {
            store.removeValue(forKey: victim)
            lruOrder.removeFirst()
        }
        store[key] = data
        lruOrder.removeAll { $0 == key }
        lruOrder.append(key)
    }

    // 2) BAD COMMENT
    /// This method inserts an image in cache and removes old values.
    func insertBadComment(_ data: Data, for key: String) {
        insertNoComment(data, for: key)
    }

    // 3) GOOD COMMENT
    /// Evicts the least-recently-used key only when inserting a new key at capacity.
    func insertGoodComment(_ data: Data, for key: String) {
        insertNoComment(data, for: key)
    }

    // 4) BEST COMMENT
    /// Assumption: `lruOrder.first` is always the least recently used key still present in `store`.
    /// Constraint: updating an existing key must not trigger eviction.
    /// Side Effects: eviction changes memory profile and can increase downstream network fetches.
    func insertBestComment(_ data: Data, for key: String) {
        insertNoComment(data, for: key)
    }
}
