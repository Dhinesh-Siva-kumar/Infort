import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the app is currently behind the biometric lock screen. Only
/// engaged when the user has explicitly enabled biometric login in Settings.
final appLockProvider = StateNotifierProvider<AppLockController, bool>((ref) {
  return AppLockController();
});

class AppLockController extends StateNotifier<bool> {
  AppLockController() : super(false);

  void engageIfEnabled(bool biometricEnabled) {
    if (biometricEnabled) state = true;
  }

  void unlock() => state = false;
}
