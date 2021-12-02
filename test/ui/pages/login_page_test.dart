import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/i18n/i18n.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    await tester.pumpWidget(makePage(path: '/login', page: () => LoginPage(presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);

    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);

    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Should presents error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = UIError.invalidField;
    presenter.emitEmailError(errorText);

    await tester.pump();

    expect(find.text(errorText.description), findsOneWidget);
  });

  testWidgets('Should presents no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();

    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.email),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should presents error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = UIError.invalidField;
    presenter.emitPasswordError(errorText);

    await tester.pump();

    expect(find.text(errorText.description), findsOneWidget);
  });

  testWidgets('Should presents no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailValid();

    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.password),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets(
    'Should presents no error if password error text is null',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitPasswordValid();

      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      );
      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitValidForm();

      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Should disable button if form is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitInvalidForm();

      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitValidForm();
      await tester.pump();
      final button = find.byType(ElevatedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);

      verify(() => presenter.auth()).called(1);
    },
  );

  testWidgets(
    'Should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitLoading();
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should hide loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitLoading();
      await tester.pump();

      presenter.emitLoading(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Should present error message if authentication fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      final error = UIError.invalidCredentials;
      presenter.emitMainError(error);
      await loadPage(tester);

      expect(find.text(error.description), findsOneWidget);
    },
  );

  testWidgets(
    'Should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitNavigateTo('/any_route');
      await tester.pumpAndSettle();

      expect(currentPage, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentPage, '/login');
  });

  testWidgets(
    'Should call go to signup on link click',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitValidForm();
      await tester.pump();

      final button = find.text(R.strings.goToSignUp);
      await tester.ensureVisible(button);
      await tester.tap(button);

      verify(() => presenter.goToSignUp()).called(1);
    },
  );
}
