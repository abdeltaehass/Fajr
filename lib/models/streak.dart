class Streak {
  final String id;
  String title;
  int currentStreak;
  int longestStreak;
  String? lastCompletedDate; // "YYYY-MM-DD"
  // Historical check-offs for the calendar view. Always includes lastCompletedDate.
  final Set<String> completedDates;

  Streak({
    required this.id,
    required this.title,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    Set<String>? completedDates,
  }) : completedDates = completedDates ?? {};

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
    completedDates.add(today);
  }

  void unmarkToday() {
    if (!isCompletedToday) return;
    completedDates.remove(today);
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
        'completedDates': completedDates.toList(),
      };

  factory Streak.fromJson(Map<String, dynamic> json) {
    final dates = (json['completedDates'] as List?)?.cast<String>().toSet() ?? <String>{};
    final lastDate = json['lastCompletedDate'] as String?;
    // Migrate legacy data: ensure last completed date is in the set
    if (lastDate != null) dates.add(lastDate);
    return Streak(
      id: json['id'] as String,
      title: json['title'] as String,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastCompletedDate: lastDate,
      completedDates: dates,
    );
  }
}
