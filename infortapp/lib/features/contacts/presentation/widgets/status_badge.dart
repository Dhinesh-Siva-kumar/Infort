import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/contact_request.dart';

Color statusColor(ContactStatus status) {
  switch (status) {
    case ContactStatus.newRequest:
      return AppColors.statusNew;
    case ContactStatus.read:
      return AppColors.statusRead;
    case ContactStatus.inProgress:
      return AppColors.statusInProgress;
    case ContactStatus.replied:
      return AppColors.statusReplied;
    case ContactStatus.closed:
      return AppColors.statusClosed;
  }
}

/// Color-coded but always paired with a text label — never color alone
/// (accessibility requirement).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ContactStatus status;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
