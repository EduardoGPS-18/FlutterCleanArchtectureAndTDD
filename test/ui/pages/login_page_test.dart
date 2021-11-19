import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController();
    passwordErrorController = StreamController();
    isFormValidController = StreamController();

    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidController).thenAnswer((_) => isFormValidController.stream);

    final loginPage = MaterialApp(
      home: LoginPage(presenter),
    );
    await tester.pumpWidget(
      loginPage,
    );
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(presenter.validateEmail(email));

    await loadPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(presenter.validatePassword(password));
  });

  testWidgets('Should presents error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = 'any error';
    emailErrorController.add(errorText);

    await tester.pump();

    expect(find.text(errorText), findsOneWidget);
  });

  testWidgets('Should presents no error if email is valid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = null;
    emailErrorController.add(errorText);

    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should presents no error if email error text is empty', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = '';
    emailErrorController.add(errorText);

    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Email'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should presents error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = 'any error';
    passwordErrorController.add(errorText);

    await tester.pump();

    expect(find.text(errorText), findsOneWidget);
  });

  testWidgets('Should presents no error if password is valid', (WidgetTester tester) async {
    await loadPage(tester);

    final errorText = null;
    emailErrorController.add(errorText);

    await tester.pump();

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('Senha'),
      matching: find.byType(Text),
    );
    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets(
    'Should presents no error if password error text is empty',
    (WidgetTester tester) async {
      await loadPage(tester);

      final errorText = '';
      passwordErrorController.add(errorText);

      await tester.pump();

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );
      expect(passwordTextChildren, findsOneWidget);
    },
  );

  testWidgets(
    'Should enable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Should disable button if form is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);

      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNull);
    },
  );
}
