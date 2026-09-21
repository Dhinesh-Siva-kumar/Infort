import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../domain/contact_request.dart';
import '../providers/contact_detail_provider.dart';
import '../widgets/status_badge.dart';

class ContactDetailScreen extends ConsumerWidget {
  const ContactDetailScreen({super.key, required this.id});

  final int id;

  Future<void> _launch(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the app for this action.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contactDetailProvider(id));
    final controller = ref.read(contactDetailProvider(id).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Request')),
      body: Builder(
        builder: (context) {
          if (state.isLoading && state.request == null)
            return const LoadingView();
          if (state.error != null && state.request == null) {
            return ErrorState(message: state.error!, onRetry: controller.load);
          }

          final request = state.request!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    StatusBadge(status: request.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _InfoRow(icon: Icons.email_outlined, text: request.email),
                _InfoRow(icon: Icons.phone_outlined, text: request.phone),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.service,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _launch(
                          context,
                          Uri(scheme: 'tel', path: request.phone),
                        ),
                        icon: const Icon(Icons.call_outlined),
                        label: const Text('Call'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _launch(
                          context,
                          Uri(scheme: 'mailto', path: request.email),
                        ),
                        icon: const Icon(Icons.email_outlined),
                        label: const Text('Email'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _launch(
                          context,
                          Uri.parse(
                            'https://wa.me/${request.phone.replaceAll(RegExp(r'[^0-9]'), '')}',
                          ),
                        ),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('WhatsApp'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Text('Message', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  request.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Submitted',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  DateFormatter.full(request.createdAt),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Update Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final status in ContactStatus.values)
                      ChoiceChip(
                        label: Text(status.label),
                        selected: request.status == status,
                        onSelected: state.isUpdatingStatus
                            ? null
                            : (_) async {
                                final ok = await controller.updateStatus(
                                  status,
                                );
                                if (!ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ref
                                                .read(contactDetailProvider(id))
                                                .error ??
                                            'Failed to update status',
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                  ],
                ),
                if (state.isUpdatingStatus) ...[
                  const SizedBox(height: AppSpacing.md),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
