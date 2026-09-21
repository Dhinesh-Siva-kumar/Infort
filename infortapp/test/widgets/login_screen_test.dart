import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:infortapp/features/auth/data/auth_repository.dart';
import 'package:infortapp/features/auth/domain/user.dart';
import 'package:infortapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:infortapp/features/auth/presentation/screens/login_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  testWidgets('shows validation errors when submitting an empty form', (
    tester,
  ) async {
    await pumpLoginScreen(tester);

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    verifyNever(() => repository.login(any(), any()));
  });

  testWidgets('toggling the visibility icon switches the obscure-text state', (
    tester,
  ) async {
    await pumpLoginScreen(tester);

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
  });

  testWidgets('submits credentials and shows a spinner while logging in', (
    tester,
  ) async {
    final completer = Completer<FounderUser>();
    when(() => repository.login('founder@infort.in', 'correct-password'))
        .thenAnswer((_) => completer.future);

    await pumpLoginScreen(tester);

    await tester.enterText(
      find.byType(TextFormField).first,
      'founder@infort.in',
    );
    await tester.enterText(find.byType(TextFormField).last, 'correct-password');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(() => repository.login('founder@infort.in', 'correct-password'))
        .called(1);

    completer.complete(
      const FounderUser(
        id: 1,
        name: 'Samuvel',
        email: 'founder@infort.in',
        phone: null,
        role: 'FOUNDER',
        isActive: true,
      ),
    );
    await tester.pump();
  });
}
