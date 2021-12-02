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
  late SignUpPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    await tester.pumpWidget(
      makePage(path: '/signup', page: () => SignUpPage(presenter: presenter)),
    );
  }

  tearDown(presenter.dispose);

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel(R.strings.name), name);
    verify(() => presenter.validateName(name));

    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
    verify(() => presenter.validateEmail(email));

    await loadPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);
    verify(() => presenter.validatePassword(password));

    await loadPage(tester);

    final passwordConfirmation = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.confirmPassword), passwordConfirmation);
    verify(() => presenter.validateConfirmPassword(passwordConfirmation));
  });

  testWidgets('Should signup page presents name error if the name error stream controller is not null', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNameError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    presenter.emitNameError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    presenter.emitNameValid();
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.name),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should signup page presents email error if the email error stream controller is not null', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    presenter.emitEmailValid();
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.email),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should signup page presents password error if the password error stream controller is not null',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    presenter.emitPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    presenter.emitPasswordValid();
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.password),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should signup page presents confirmPassword error if the confirmPassword error stream controller is not null',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitConfirmPasswordError(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    presenter.emitConfirmPasswordError(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    presenter.emitConfirmPasswordValid();
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel(R.strings.confirmPassword),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Should disable signup button if form is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitConfirmPasswordValid();

    await tester.pump();

    final signupButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(signupButton.onPressed, isNull);
  });

  testWidgets('Should turn signup button valid if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitValidForm();

    await tester.pump();

    final signupButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(signupButton.onPressed, isNotNull);
  });

  testWidgets('Should call signUp on form submit', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitValidForm();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenter.signUp()).called(1);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    presenter.emitLoading(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should show loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should present error message if signup fails', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.emailInUse);
    await tester.pump();

    expect(find.text(R.strings.emailInUse), findsOneWidget);
  });

  testWidgets('Should present error message if signup throws', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitMainError(UIError.unexpected);
    await tester.pump();

    expect(find.text(R.strings.unexpected), findsOneWidget);
  });

  testWidgets('Should navigate on signup with success', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentPage, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not navigate if signup with success but invalid route', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pumpAndSettle();
    expect(currentPage, '/signup');
  });

  testWidgets(
    'Should call go to login on link click',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitValidForm();
      await loadPage(tester);
      final button = find.text(R.strings.goToLogin);
      await tester.ensureVisible(button);
      await tester.tap(button);

      verify(() => presenter.goToLogin()).called(1);
    },
  );
}
