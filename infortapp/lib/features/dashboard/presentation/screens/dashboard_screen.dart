import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../contacts/presentation/widgets/contact_tile.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/greeting_hero.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
    final authState = ref.watch(authControllerProvider);
    final name = authState is Authenticated ? authState.user.name.split(' ').first : '';

    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.summary == null) return const LoadingView();
            if (state.error != null && state.summary == null) {
              return ErrorState(
                message: state.error!,
                onRetry: () => ref.read(dashboardProvider.notifier).refresh(),
              );
            }

            final summary = state.summary!;

            return RefreshIndicator(
              onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
                children: [
                  GreetingHero(greeting: _greeting(), name: name),
                  const SizedBox(height: AppSpacing.xl),
                  Text("Today's Overview", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.5,
                    children: [
                      StatCard(
                        label: 'Contact Requests',
                        value: summary.total,
                        icon: Icons.mail_outline,
                        color: AppColors.info,
                      ),
                      StatCard(
                        label: 'New Today',
                        value: summary.todayCount,
                        icon: Icons.fiber_new_rounded,
                        color: AppColors.success,
                      ),
                      StatCard(
                        label: 'New',
                        value: summary.newCount,
                        icon: Icons.markunread_outlined,
                        color: AppColors.primary,
                      ),
                      StatCard(
                        label: 'Pending',
                        value: summary.pendingCount,
                        icon: Icons.pending_actions_outlined,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Contact Requests', style: Theme.of(context).textTheme.titleMedium),
                      TextButton(
                        onPressed: () => context.go('/contact-requests'),
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.recent.isEmpty)
                    const EmptyState(icon: Icons.inbox_outlined, title: 'No contact requests yet')
                  else
                    ...state.recent.map(
                      (request) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ContactTile(
                          request: request,
                          onTap: () => context.push('/contact-requests/${request.id}'),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
