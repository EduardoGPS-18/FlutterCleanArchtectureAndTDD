import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;

  StreamController<String> mainErrorController;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;

  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    mainErrorController = StreamController();
    isLoadingController = StreamController();
    emailErrorController = StreamController();
    isFormValidController = StreamController();
    passwordErrorController = StreamController();
  }

  void mockStreams() {
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
  }

  void closeStreams() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = MaterialApp(
      home: LoginPage(presenter),
    );
    await tester.pumpWidget(
      loginPage,
    );
  }

  tearDown(closeStreams);

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
    expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets(
    'Should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await loadPage(tester);
      await tester.tap(find.byType(RaisedButton));

      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    'Should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should hide loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await loadPage(tester);
      isLoadingController.add(false);
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Should present error message if authentication fails',
    (WidgetTester tester) async {
      await loadPage(tester);

      final error = 'main error';
      mainErrorController.add(error);
      await loadPage(tester);

      expect(find.text(error), findsOneWidget);
    },
  );

  testWidgets(
    'Should close streams on dispose',
    (WidgetTester tester) async {
      await loadPage(tester);

      addTearDown(() {
        verify(presenter.dispose()).called(1);
      });
    },
  );
}
