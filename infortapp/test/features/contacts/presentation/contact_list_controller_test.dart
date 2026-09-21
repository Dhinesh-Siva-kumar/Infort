import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:infortapp/core/errors/app_exception.dart';
import 'package:infortapp/features/contacts/data/contact_repository.dart';
import 'package:infortapp/features/contacts/domain/contact_request.dart';
import 'package:infortapp/features/contacts/presentation/providers/contact_list_provider.dart';
import 'package:infortapp/shared/models/paginated_response.dart';

class MockContactRepository extends Mock implements ContactRepository {}

ContactRequest _request(
  int id, {
  ContactStatus status = ContactStatus.newRequest,
}) {
  return ContactRequest(
    id: id,
    name: 'Person $id',
    email: 'person$id@example.com',
    phone: '9876543210',
    service: 'web-development',
    message: 'A message that is long enough to pass validation.',
    status: status,
    createdAt: DateTime(2026, 9, 21),
    updatedAt: DateTime(2026, 9, 21),
  );
}

void main() {
  late MockContactRepository repository;

  setUp(() {
    repository = MockContactRepository();
  });

  test('loads page 1 on construction', () async {
    when(
      () => repository.list(
        page: 1,
        search: '',
        status: null,
        sort: ContactSort.newest,
      ),
    ).thenAnswer(
      (_) async => PaginatedResponse(
        items: [_request(1), _request(2)],
        page: 1,
        limit: 20,
        total: 2,
      ),
    );

    final controller = ContactListController(repository);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state.items.length, 2);
    expect(controller.state.isLoading, isFalse);
    expect(controller.state.hasMore, isFalse);
  });

  test(
    'loadMore appends the next page and advances the page counter',
    () async {
      when(
        () => repository.list(
          page: 1,
          search: '',
          status: null,
          sort: ContactSort.newest,
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          items: [_request(1)],
          page: 1,
          limit: 1,
          total: 2,
        ),
      );
      when(
        () => repository.list(
          page: 2,
          search: '',
          status: null,
          sort: ContactSort.newest,
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          items: [_request(2)],
          page: 2,
          limit: 1,
          total: 2,
        ),
      );

      final controller = ContactListController(repository);
      await Future<void>.delayed(Duration.zero);
      expect(controller.state.hasMore, isTrue);

      await controller.loadMore();

      expect(controller.state.items.map((r) => r.id), [1, 2]);
      expect(controller.state.page, 2);
      expect(controller.state.hasMore, isFalse);
    },
  );

  test('setStatusFilter refetches with the filter applied', () async {
    when(
      () => repository.list(
        page: 1,
        search: '',
        status: null,
        sort: ContactSort.newest,
      ),
    ).thenAnswer(
      (_) async =>
          PaginatedResponse(items: [_request(1)], page: 1, limit: 20, total: 1),
    );
    when(
      () => repository.list(
        page: 1,
        search: '',
        status: ContactStatus.replied,
        sort: ContactSort.newest,
      ),
    ).thenAnswer(
      (_) async => PaginatedResponse(
        items: [_request(2, status: ContactStatus.replied)],
        page: 1,
        limit: 20,
        total: 1,
      ),
    );

    final controller = ContactListController(repository);
    await Future<void>.delayed(Duration.zero);

    controller.setStatusFilter(ContactStatus.replied);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state.items.single.status, ContactStatus.replied);
  });

  test(
    'surfaces a friendly error message when the initial load fails',
    () async {
      when(
        () => repository.list(
          page: 1,
          search: '',
          status: null,
          sort: ContactSort.newest,
        ),
      ).thenThrow(const NetworkException());

      final controller = ContactListController(repository);
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.error, isNotNull);
      expect(controller.state.items, isEmpty);
    },
  );

  test(
    'applyStatusUpdate replaces the matching item in place without refetching',
    () async {
      when(
        () => repository.list(
          page: 1,
          search: '',
          status: null,
          sort: ContactSort.newest,
        ),
      ).thenAnswer(
        (_) async => PaginatedResponse(
          items: [_request(1), _request(2)],
          page: 1,
          limit: 20,
          total: 2,
        ),
      );

      final controller = ContactListController(repository);
      await Future<void>.delayed(Duration.zero);

      controller.applyStatusUpdate(_request(2, status: ContactStatus.closed));

      expect(
        controller.state.items.firstWhere((r) => r.id == 2).status,
        ContactStatus.closed,
      );
      verifyNever(() => repository.getById(any()));
    },
  );
}
