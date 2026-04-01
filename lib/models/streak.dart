class Streak {
  final String id;
  String title;
  int currentStreak;
  int longestStreak;
  String? lastCompletedDate; // "YYYY-MM-DD"

  Streak({
    required this.id,
    required this.title,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
  });

  String get today => DateTime.now().toIso8601String().substring(0, 10);

  bool get isCompletedToday => lastCompletedDate == today;

  bool get isStreakActive {
    if (lastCompletedDate == null) return false;
    final last = DateTime.parse(lastCompletedDate!);
    final diff = DateTime.now().difference(last).inDays;
    return diff <= 1;
  }

  /// Resets streak if a day was missed. Returns true if state changed.
  bool recalculateOnOpen() {
    if (lastCompletedDate == null || isCompletedToday) return false;
    final last = DateTime.parse(lastCompletedDate!);
    final diff = DateTime.now().difference(last).inDays;
    if (diff > 1) { currentStreak = 0; return true; }
    return false;
  }

  void markToday() {
    if (isCompletedToday) return;
    recalculateOnOpen();
    currentStreak += 1;
    if (currentStreak > longestStreak) longestStreak = currentStreak;
    lastCompletedDate = today;
  }

  void unmarkToday() {
    if (!isCompletedToday) return;
    currentStreak = (currentStreak - 1).clamp(0, 999);
    lastCompletedDate = currentStreak == 0 ? null : _yesterday;
  }

  String get _yesterday {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return y.toIso8601String().substring(0, 10);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastCompletedDate': lastCompletedDate,
      };

  factory Streak.fromJson(Map<String, dynamic> json) => Streak(
        id: json['id'] as String,
        title: json['title'] as String,
        currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int,
        lastCompletedDate: json['lastCompletedDate'] as String?,
      );
}
