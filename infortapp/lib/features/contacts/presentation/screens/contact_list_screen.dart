import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../data/contact_repository.dart';
import '../../domain/contact_request.dart';
import '../providers/contact_list_provider.dart';
import '../widgets/contact_tile.dart';

class ContactListScreen extends ConsumerStatefulWidget {
  const ContactListScreen({super.key});

  @override
  ConsumerState<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends ConsumerState<ContactListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(contactListProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactListProvider);
    final controller = ref.read(contactListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Requests')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: TextField(
              onChanged: controller.setSearch,
              decoration: const InputDecoration(
                hintText: 'Search by name, email, phone, service',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _FilterChip(
                  label: 'All',
                  selected: state.statusFilter == null,
                  onSelected: () => controller.setStatusFilter(null),
                ),
                for (final status in ContactStatus.values) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _FilterChip(
                    label: status.label,
                    selected: state.statusFilter == status,
                    onSelected: () => controller.setStatusFilter(status),
                  ),
                ],
                const SizedBox(width: AppSpacing.sm),
                PopupMenuButton<ContactSort>(
                  initialValue: state.sort,
                  onSelected: controller.setSort,
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: ContactSort.newest,
                      child: Text('Newest First'),
                    ),
                    PopupMenuItem(
                      value: ContactSort.oldest,
                      child: Text('Oldest First'),
                    ),
                  ],
                  child: Chip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          state.sort == ContactSort.newest
                              ? 'Newest'
                              : 'Oldest',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(child: _buildBody(state, controller)),
        ],
      ),
    );
  }

  Widget _buildBody(ContactListState state, ContactListController controller) {
    if (state.isLoading && state.items.isEmpty) return const LoadingView();

    if (state.error != null && state.items.isEmpty) {
      return ErrorState(message: state.error!, onRetry: controller.refresh);
    }

    if (state.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'No contact requests',
        message: 'New requests submitted from the website will show up here.',
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final request = state.items[index];
          return ContactTile(
            request: request,
            onTap: () => context.push('/contact-requests/${request.id}'),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}
