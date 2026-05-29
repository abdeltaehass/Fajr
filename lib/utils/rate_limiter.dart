/// Per-key minimum-interval rate limiter. Use this to prevent rapid-fire
/// calls to expensive operations (network requests, geo lookups, etc.).
///
/// Example:
///   final limiter = RateLimiter();
///   if (!limiter.tryAcquire('refresh', const Duration(seconds: 15))) {
///     return; // Last call was less than 15 s ago — skip.
///   }
///   await fetchSomething();
class RateLimiter {
  final Map<String, DateTime> _lastCalls = {};

  /// Returns true if the call may proceed, false if the previous call to
  /// the same `key` happened more recently than `minInterval` ago. Records
  /// the current time on success so subsequent calls are gated.
  bool tryAcquire(String key, Duration minInterval) {
    final last = _lastCalls[key];
    final now = DateTime.now();
    if (last != null && now.difference(last) < minInterval) return false;
    _lastCalls[key] = now;
    return true;
  }

  /// How long until the next call to `key` is allowed. Useful for showing
  /// a "please wait N seconds" message in the UI.
  Duration timeUntilNextAllowed(String key, Duration minInterval) {
    final last = _lastCalls[key];
    if (last == null) return Duration.zero;
    final elapsed = DateTime.now().difference(last);
    final remaining = minInterval - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Clear the throttle for a specific key — for example, after a failed
  /// request you may want the user to be able to retry immediately.
  void reset(String key) => _lastCalls.remove(key);
}
