import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/notification_api.dart';
import '../../data/notification_repository.dart';
import '../../domain/app_notification.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(NotificationApi(ref.watch(apiClientProvider)));
});

class NotificationListState {
  const NotificationListState({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  final List<AppNotification> items;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final String? error;

  int get unreadCount => items.where((n) => n.isUnread).length;

  NotificationListState copyWith({
    List<AppNotification>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return NotificationListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final notificationListProvider =
    StateNotifierProvider<NotificationListController, NotificationListState>((
      ref,
    ) {
      return NotificationListController(
        ref.watch(notificationRepositoryProvider),
      );
    });

class NotificationListController extends StateNotifier<NotificationListState> {
  NotificationListController(this._repository)
    : super(const NotificationListState()) {
    refresh();
  }

  final NotificationRepository _repository;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repository.list(page: 1);
      state = state.copyWith(
        items: result.items,
        page: 1,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    try {
      final nextPage = state.page + 1;
      final result = await _repository.list(page: nextPage);
      state = state.copyWith(
        items: [...state.items, ...result.items],
        page: nextPage,
        hasMore: result.hasMore,
      );
    } on AppException {
      // Silently keep current page — user can pull to refresh.
    }
  }

  Future<void> markRead(int id) async {
    final previous = state.items;
    state = state.copyWith(
      items: [
        for (final n in state.items)
          if (n.id == id) n.markRead() else n,
      ],
    );
    try {
      await _repository.markRead(id);
    } on AppException {
      state = state.copyWith(items: previous);
    }
  }

  Future<void> markAllRead() async {
    final previous = state.items;
    state = state.copyWith(items: [for (final n in state.items) n.markRead()]);
    try {
      await _repository.markAllRead();
    } on AppException {
      state = state.copyWith(items: previous);
    }
  }
}
