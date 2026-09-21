import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../../core/utils/biometric_auth_service.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>(
  (ref) => BiometricAuthService(),
);

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.biometricEnabled,
  });

  final ThemeMode themeMode;
  final bool biometricEnabled;

  SettingsState copyWith({ThemeMode? themeMode, bool? biometricEnabled}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
      final prefs = ref.watch(appPreferencesProvider);
      final initialThemeMode = switch (prefs.themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      return SettingsController(
        prefs,
        SettingsState(
          themeMode: initialThemeMode,
          biometricEnabled: prefs.biometricEnabled,
        ),
      );
    });

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._prefs, super.state);

  final AppPreferences _prefs;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setThemeMode(switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled);
    await _prefs.setBiometricEnabled(enabled);
  }
}
