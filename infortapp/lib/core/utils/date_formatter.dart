import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// "Today, 10:32 AM" / "Yesterday, 4:20 PM" / "12 Sep 2026, 4:20 PM"
  static String friendly(DateTime dateTime) {
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(local.year, local.month, local.day);
    final time = DateFormat('h:mm a').format(local);

    if (date == today) return 'Today, $time';
    if (date == today.subtract(const Duration(days: 1)))
      return 'Yesterday, $time';
    return '${DateFormat('d MMM yyyy').format(local)}, $time';
  }

  /// "2 hours ago" / "5 minutes ago" / "Just now"
  static String relative(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime.toLocal());
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60)
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    if (diff.inHours < 24)
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    if (diff.inDays < 7)
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    return DateFormat('d MMM yyyy').format(dateTime.toLocal());
  }

  static String full(DateTime dateTime) {
    return DateFormat('d MMMM yyyy · h:mm a').format(dateTime.toLocal());
  }
}
