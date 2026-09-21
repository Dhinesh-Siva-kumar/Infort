class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.contactSubmissionId,
    required this.readAt,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      contactSubmissionId: json['contact_submission_id'] as int?,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  final int id;
  final String type;
  final String title;
  final String body;
  final int? contactSubmissionId;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get isUnread => readAt == null;

  AppNotification markRead() => AppNotification(
    id: id,
    type: type,
    title: title,
    body: body,
    contactSubmissionId: contactSubmissionId,
    readAt: DateTime.now(),
    createdAt: createdAt,
  );
}
