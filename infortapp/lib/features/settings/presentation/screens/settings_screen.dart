import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final biometricService = ref.read(biometricAuthServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _SectionLabel('Appearance'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.smartphone),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (selection) =>
                    controller.setThemeMode(selection.first),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel('Security'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Biometric Login'),
              subtitle: const Text(
                'Unlock the app with fingerprint or Face ID',
              ),
              value: settings.biometricEnabled,
              onChanged: (value) async {
                if (!value) {
                  await controller.setBiometricEnabled(false);
                  return;
                }
                final supported = await biometricService.isDeviceSupported();
                if (!supported) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Biometric authentication is not available on this device.',
                        ),
                      ),
                    );
                  }
                  return;
                }
                final confirmed = await biometricService.authenticate(
                  'Confirm to enable biometric login',
                );
                if (confirmed) {
                  await controller.setBiometricEnabled(true);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Biometric setup was cancelled.'),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionLabel('About'),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showStaticInfo(
                    context,
                    'Privacy Policy',
                    'Infort Solutions respects your privacy. This app only stores the data needed to manage contact requests submitted through the Infort website, and access is restricted to the Founder/Owner account.',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showStaticInfo(
                    context,
                    'Terms',
                    'This application is for internal use by the Infort Solutions Founder/Owner only.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await showConfirmDialog(
                context,
                title: 'Log out',
                message: 'Are you sure you want to log out of Infort?',
                confirmLabel: 'Log out',
                isDestructive: true,
              );
              if (confirmed) {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              }
            },
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showStaticInfo(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
