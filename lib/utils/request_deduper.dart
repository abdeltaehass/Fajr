/// Coalesces concurrent calls to the same expensive async operation. When
/// N callers ask for the same key in parallel, only one underlying Future
/// is created; everyone awaits the same result.
///
/// Cuts redundant network requests when the UI rapidly re-asks for the
/// same data (e.g. switching screens before the previous load finishes).
///
/// Example:
///   final deduper = RequestDeduper&lt;List&lt;Masjid&gt;&gt;();
///   return deduper.run('nearby_$lat_$lng', () => _doActualHttpCall());
class RequestDeduper<T> {
  final Map<String, Future<T>> _inFlight = {};

  /// If a request for `key` is already running, returns its Future.
  /// Otherwise calls `producer` once and returns its result, removing
  /// the entry from the in-flight map when it settles (success or error).
  Future<T> run(String key, Future<T> Function() producer) {
    final existing = _inFlight[key];
    if (existing != null) return existing;

    final future = producer();
    _inFlight[key] = future;
    // Use whenComplete instead of try/finally so we don't swallow errors.
    future.whenComplete(() => _inFlight.remove(key));
    return future;
  }
}
