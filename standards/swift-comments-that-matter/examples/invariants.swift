import Foundation

// MARK: - Download Manager Deduplication Invariant

final class DownloadManager {
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let session: URLSession = .shared

    // 1) NO COMMENT
    func startNoComment(fileKey: String, url: URL) -> URLSessionDataTask {
        if let existing = activeTasks[fileKey] {
            return existing
        }
        let task = session.dataTask(with: url)
        activeTasks[fileKey] = task
        task.resume()
        return task
    }

    // 2) BAD COMMENT
    /// This function starts a download for the file.
    func startBadComment(fileKey: String, url: URL) -> URLSessionDataTask {
        startNoComment(fileKey: fileKey, url: url)
    }

    // 3) GOOD COMMENT
    /// Reuses the in-flight task for the same `fileKey` to avoid duplicate downloads.
    func startGoodComment(fileKey: String, url: URL) -> URLSessionDataTask {
        startNoComment(fileKey: fileKey, url: url)
    }

    // 4) BEST COMMENT
    /// Invariant: each `fileKey` maps to at most one active network task.
    /// Constraint: callers requesting the same key must receive the same task instance.
    /// Why: duplicate tasks race on file finalization and can corrupt checksum verification.
    func startBestComment(fileKey: String, url: URL) -> URLSessionDataTask {
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
