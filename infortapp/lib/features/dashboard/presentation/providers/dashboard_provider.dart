import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../contacts/data/contact_repository.dart';
import '../../../contacts/domain/contact_request.dart';
import '../../../contacts/domain/contact_summary.dart';
import '../../../contacts/presentation/providers/contact_list_provider.dart';

class DashboardState {
  const DashboardState({
    this.summary,
    this.recent = const [],
    this.isLoading = true,
    this.error,
  });

  final ContactSummary? summary;
  final List<ContactRequest> recent;
  final bool isLoading;
  final String? error;

  DashboardState copyWith({
    ContactSummary? summary,
    List<ContactRequest>? recent,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      summary: summary ?? this.summary,
      recent: recent ?? this.recent,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      return DashboardController(ref);
    });

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController(this._ref) : super(const DashboardState()) {
    refresh();
  }

  final Ref _ref;

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = _ref.read(contactRepositoryProvider);
      final summary = await repository.summary();
      final recent = await repository.list(
        page: 1,
        limit: 5,
        sort: ContactSort.newest,
      );
      state = state.copyWith(
        summary: summary,
        recent: recent.items,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }
}
