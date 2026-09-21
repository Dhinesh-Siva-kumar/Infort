import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationListProvider);
    final controller = ref.read(notificationListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: controller.markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading && state.items.isEmpty)
            return const LoadingView();
          if (state.error != null && state.items.isEmpty) {
            return ErrorState(
              message: state.error!,
              onRetry: controller.refresh,
            );
          }
          if (state.items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications yet',
              message: 'You\'ll be notified here when a new contact request comes in.',
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >
                    notification.metrics.maxScrollExtent - 200) {
                  controller.loadMore();
                }
                return false;
              },
              child: ListView.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = state.items[index];
                  return NotificationTile(
                    notification: notification,
                    onTap: () {
                      if (notification.isUnread)
                        controller.markRead(notification.id);
                      if (notification.contactSubmissionId != null) {
                        context.push(
                          '/contact-requests/${notification.contactSubmissionId}',
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
