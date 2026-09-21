import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/contact_api.dart';
import '../../data/contact_repository.dart';
import '../../domain/contact_request.dart';

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository(ContactApi(ref.watch(apiClientProvider)));
});

class ContactListState {
  const ContactListState({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.search = '',
    this.statusFilter,
    this.sort = ContactSort.newest,
  });

  final List<ContactRequest> items;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String search;
  final ContactStatus? statusFilter;
  final ContactSort sort;

  bool get isEmpty => items.isEmpty && !isLoading && error == null;

  ContactListState copyWith({
    List<ContactRequest>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
    String? search,
    ContactStatus? statusFilter,
    bool clearStatusFilter = false,
    ContactSort? sort,
  }) {
    return ContactListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      search: search ?? this.search,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      sort: sort ?? this.sort,
    );
  }
}

final contactListProvider =
    StateNotifierProvider<ContactListController, ContactListState>((ref) {
      return ContactListController(ref.watch(contactRepositoryProvider));
    });

class ContactListController extends StateNotifier<ContactListState> {
  ContactListController(this._repository) : super(const ContactListState()) {
    refresh();
  }

  final ContactRepository _repository;
  Timer? _debounce;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repository.list(
        page: 1,
        search: state.search,
        status: state.statusFilter,
        sort: state.sort,
      );
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
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.page + 1;
      final result = await _repository.list(
        page: nextPage,
        search: state.search,
        status: state.statusFilter,
        sort: state.sort,
      );
      state = state.copyWith(
        items: [...state.items, ...result.items],
        page: nextPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.message);
    }
  }

  void setSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(search: value);
      refresh();
    });
  }

  void setStatusFilter(ContactStatus? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true);
    } else {
      state = state.copyWith(statusFilter: status);
    }
    refresh();
  }

  void setSort(ContactSort sort) {
    state = state.copyWith(sort: sort);
    refresh();
  }

  /// Applies a status update to the cached item in-place, after the backend
  /// call already succeeded — used when returning from the detail screen.
  void applyStatusUpdate(ContactRequest updated) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.id == updated.id) updated else item,
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
