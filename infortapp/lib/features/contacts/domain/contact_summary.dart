class ContactSummary {
  const ContactSummary({
    required this.total,
    required this.newCount,
    required this.todayCount,
    required this.pendingCount,
  });

  factory ContactSummary.fromJson(Map<String, dynamic> json) {
    return ContactSummary(
      total: (json['total'] as num).toInt(),
      newCount: (json['newCount'] as num).toInt(),
      todayCount: (json['todayCount'] as num).toInt(),
      pendingCount: (json['pendingCount'] as num).toInt(),
    );
  }

  final int total;
  final int newCount;
  final int todayCount;
  final int pendingCount;
}
