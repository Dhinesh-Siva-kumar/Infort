import 'package:flutter/material.dart';

/// Matches the Infort brand red/rose used on the marketing site
/// (frontend/tailwind.config.js `theme.extend.colors.primary`).
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFDC2626);
  static const Color primaryDark = Color(0xFFB91C1C);
  static const Color primaryLight = Color(0xFFFFF1F2);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Status colors — one consistent mapping used everywhere a
  // ContactStatus is rendered (badges, filter chips, dashboard).
  static const Color statusNew = Color(0xFF2563EB);
  static const Color statusRead = Color(0xFF64748B);
  static const Color statusInProgress = Color(0xFFD97706);
  static const Color statusReplied = Color(0xFF16A34A);
  static const Color statusClosed = Color(0xFF334155);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const Color darkBackground = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF141B2D);
  static const Color darkBorder = Color(0xFF243044);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
}
