import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:infortapp/core/errors/app_exception.dart';
import 'package:infortapp/features/auth/data/auth_repository.dart';
import 'package:infortapp/features/auth/domain/user.dart';
import 'package:infortapp/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late AuthController controller;

  final user = FounderUser(
    id: 1,
    name: 'Samuvel',
    email: 'founder@infort.in',
    phone: null,
    role: 'FOUNDER',
    isActive: true,
  );

  setUp(() {
    repository = MockAuthRepository();
    controller = AuthController(repository);
  });

  test('starts in AuthInitial', () {
    expect(controller.state, isA<AuthInitial>());
  });

  group('checkAuthStatus', () {
    test(
      'goes straight to Unauthenticated when no session is stored',
      () async {
        when(() => repository.hasStoredSession())
            .thenAnswer((_) async => false);

        await controller.checkAuthStatus();

        expect(controller.state, isA<Unauthenticated>());
        verifyNever(() => repository.fetchCurrentUser());
      },
    );

    test('rehydrates the user when a stored session is valid', () async {
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
      when(() => repository.fetchCurrentUser()).thenAnswer((_) async => user);

      await controller.checkAuthStatus();

      expect(controller.state, isA<Authenticated>());
      expect(
        (controller.state as Authenticated).user.email,
        'founder@infort.in',
      );
    });

    test('falls back to Unauthenticated when the stored token is rejected by the backend', () async {
      when(() => repository.hasStoredSession()).thenAnswer((_) async => true);
      when(() => repository.fetchCurrentUser())
          .thenThrow(const UnauthorizedException());

      await controller.checkAuthStatus();

      expect(controller.state, isA<Unauthenticated>());
    });
  });

  group('login', () {
    test('transitions to Authenticated on success', () async {
      when(() => repository.login('founder@infort.in', 'correct-password'))
          .thenAnswer((_) async => user);

      await controller.login('founder@infort.in', 'correct-password');

      expect(controller.state, isA<Authenticated>());
    });

    test(
      'surfaces the backend error message on failure and stays unauthenticated',
      () async {
        when(
          () => repository.login('founder@infort.in', 'wrong-password'),
        ).thenThrow(const UnauthorizedException('Invalid email or password'));

        await controller.login('founder@infort.in', 'wrong-password');

        final state = controller.state;
        expect(state, isA<Unauthenticated>());
        expect((state as Unauthenticated).message, 'Invalid email or password');
      },
    );
  });

  test('logout clears the session and returns to Unauthenticated', () async {
    when(() => repository.logout()).thenAnswer((_) async {});

    await controller.logout();

    expect(controller.state, isA<Unauthenticated>());
    verify(() => repository.logout()).called(1);
  });

  test('forceLogout (called by ApiClient on a failed refresh) drops back to Unauthenticated', () {
    controller.forceLogout();

    final state = controller.state;
    expect(state, isA<Unauthenticated>());
    expect((state as Unauthenticated).message, contains('session has expired'));
  });
}
