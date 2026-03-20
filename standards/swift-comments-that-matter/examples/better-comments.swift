import Foundation

// Production-oriented rewrites that emphasize intent and risk.

final class BackgroundRefreshScheduler {
    // 1) NO COMMENT
    func scheduleNoComment(lastRunAt: Date?, now: Date = .init()) -> Bool {
        guard let lastRunAt else { return true }
        return now.timeIntervalSince(lastRunAt) > 15 * 60
    }

    // 2) BAD COMMENT
    /// This method decides if we should schedule a background refresh.
    func scheduleBadComment(lastRunAt: Date?, now: Date = .init()) -> Bool {
        scheduleNoComment(lastRunAt: lastRunAt, now: now)
    }

    // 3) GOOD COMMENT
    /// Enforces a 15-minute minimum interval to avoid OS throttling penalties.
    func scheduleGoodComment(lastRunAt: Date?, now: Date = .init()) -> Bool {
        scheduleNoComment(lastRunAt: lastRunAt, now: now)
    }

    // 4) BEST COMMENT
    /// Constraint: schedule no more than once per 15 minutes per process lifetime.
    /// Why: aggressive scheduling reduces background execution budget and delays future refresh opportunities.
    /// Assumption: caller stores `lastRunAt` durably across launches.
    func scheduleBestComment(lastRunAt: Date?, now: Date = .init()) -> Bool {
        scheduleNoComment(lastRunAt: lastRunAt, now: now)
    }
}

final class ResponseCache {
    private var values: [URL: Data] = [:]

    // 1) NO COMMENT
    func putNoComment(_ data: Data, for url: URL) {
        values[url] = data
    }

    // 2) BAD COMMENT
    /// This method stores response data in cache.
    func putBadComment(_ data: Data, for url: URL) {
        putNoComment(data, for: url)
    }

    // 3) GOOD COMMENT
    /// Stores raw response bytes; validation headers are handled by caller policy.
    func putGoodComment(_ data: Data, for url: URL) {
        putNoComment(data, for: url)
    }

    // 4) BEST COMMENT
    /// Assumption: caller has already validated cacheability (status code and policy headers).
    /// Side Effects: stale writes here can shadow fresher network responses until eviction.
    /// Why: cache policy is centralized upstream to keep this layer deterministic and testable.
    func putBestComment(_ data: Data, for url: URL) {
        putNoComment(data, for: url)
    }
}
