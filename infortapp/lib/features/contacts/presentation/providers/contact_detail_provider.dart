import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/contact_request.dart';
import 'contact_list_provider.dart';

class ContactDetailState {
  const ContactDetailState({
    this.request,
    this.isLoading = true,
    this.error,
    this.isUpdatingStatus = false,
  });

  final ContactRequest? request;
  final bool isLoading;
  final String? error;
  final bool isUpdatingStatus;

  ContactDetailState copyWith({
    ContactRequest? request,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isUpdatingStatus,
  }) {
    return ContactDetailState(
      request: request ?? this.request,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }
}

final contactDetailProvider =
    StateNotifierProvider.family<
      ContactDetailController,
      ContactDetailState,
      int
    >((ref, id) {
      return ContactDetailController(ref, id);
    });

class ContactDetailController extends StateNotifier<ContactDetailState> {
  ContactDetailController(this._ref, this._id)
    : super(const ContactDetailState()) {
    load();
  }

  final Ref _ref;
  final int _id;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final request = await _ref.read(contactRepositoryProvider).getById(_id);
      state = state.copyWith(request: request, isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    }
  }

  Future<bool> updateStatus(ContactStatus status) async {
    state = state.copyWith(isUpdatingStatus: true);
    try {
      final updated = await _ref
          .read(contactRepositoryProvider)
          .updateStatus(_id, status);
      state = state.copyWith(request: updated, isUpdatingStatus: false);
      _ref.read(contactListProvider.notifier).applyStatusUpdate(updated);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isUpdatingStatus: false, error: e.message);
      return false;
    }
  }
}
