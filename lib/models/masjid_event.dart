class MasjidEvent {
  final String id;
  final String title;
  final DateTime date;
  final String description;

  const MasjidEvent({
    required this.id,
    required this.title,
    required this.date,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
      };

  factory MasjidEvent.fromJson(Map<String, dynamic> json) => MasjidEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        date: DateTime.parse(json['date'] as String),
        description: json['description'] as String? ?? '',
      );
}
