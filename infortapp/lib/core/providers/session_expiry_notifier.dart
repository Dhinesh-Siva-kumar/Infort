import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Breaks the ApiClient <-> AuthController circular dependency: ApiClient
/// calls [notify] on a 401 refresh failure; AuthController registers itself
/// as the [onExpired] listener without either provider depending on the
/// other's type at construction time.
class SessionExpiryNotifier {
  VoidCallback? onExpired;

  void notify() => onExpired?.call();
}

final sessionExpiryNotifierProvider = Provider<SessionExpiryNotifier>((ref) {
  return SessionExpiryNotifier();
});
