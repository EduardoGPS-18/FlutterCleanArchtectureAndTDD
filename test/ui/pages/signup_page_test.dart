import 'dart:async';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';
import 'package:app_curso_manguinho/ui/helpers/i18n/i18n.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<bool> isFormValidController;

  void initStreams() {
    nameErrorController = StreamController();
    emailErrorController = StreamController();
    passwordErrorController = StreamController();
    passwordConfirmationErrorController = StreamController();
    isFormValidController = StreamController();
  }

  void mockStreams() {
    when(presenter.nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
      ],
    );
    await tester.pumpWidget(
      signUpPage,
    );
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    isFormValidController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.name),
      matching: find.byType(Text),
    );

    expect(
      nameTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.email),
      matching: find.byType(Text),
    );

    expect(
      emailTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.password),
      matching: find.byType(Text),
    );

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final passwordConfirmationTextChildren = find.descendant(
      of: find.bySemanticsLabel(R.strings.confirmPassword),
      matching: find.byType(Text),
    );

    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values', (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel(R.strings.name), name);
    verify(presenter.validateName(name));

    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(R.strings.email), email);
    verify(presenter.validateEmail(email));

    await loadPage(tester);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.password), password);
    verify(presenter.validatePassword(password));

    await loadPage(tester);

    final passwordConfirmation = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel(R.strings.confirmPassword), passwordConfirmation);
    verify(presenter.validateConfirmPassword(passwordConfirmation));
  });

  testWidgets('Should signup page presents name error if the name error stream controller is not null', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    nameErrorController.add(null);
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

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    emailErrorController.add(null);
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

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    passwordErrorController.add(null);
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

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text(R.strings.invalidField), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text(R.strings.requiredField), findsOneWidget);

    passwordConfirmationErrorController.add(null);
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

    isFormValidController.add(false);

    await tester.pump();

    final signupButton = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(signupButton.onPressed, isNull);
  });

  testWidgets('Should turn signup button valid if form is valid', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);

    await tester.pump();

    final signupButton = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(signupButton.onPressed, isNotNull);
  });
}
