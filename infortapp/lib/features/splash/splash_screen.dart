import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_lock_provider.dart';
import '../auth/presentation/providers/auth_provider.dart';
import '../settings/presentation/providers/settings_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authControllerProvider.notifier).checkAuthStatus();
      if (!mounted) return;
      if (ref.read(authControllerProvider) is Authenticated) {
        final biometricEnabled = ref
            .read(settingsControllerProvider)
            .biometricEnabled;
        ref.read(appLockProvider.notifier).engageIfEnabled(biometricEnabled);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/infort_logo.png',
              height: 72,
              errorBuilder: (_, _, _) => Icon(
                Icons.business_center_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
