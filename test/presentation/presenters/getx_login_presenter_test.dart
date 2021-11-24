import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  String email;
  String token;
  String password;
  Validation validation;
  LoginPresenter sut;
  SaveCurrentAccount saveCurrentAccount;

  Authentication authentication;

  PostExpectation mockValidationCall([String field]) => when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        input: anyNamed('input'),
      ));
  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: anyNamed('params')));
  void mockAuthentication() => mockAuthenticationCall().thenAnswer(
        (_) async => AccountEntity(token: token),
      );
  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));
  void mockSaveCurrentAccountError(DomainError error) => mockSaveCurrentAccountCall().thenThrow(error);

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(
      validation: validation,
      authenticationUsecase: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    token = faker.guid.guid();
    email = faker.internet.email();
    password = faker.internet.password();
    mockAuthentication();
    mockValidation();
  });

  test('(GETX LOGIN PRESENTER) : Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', input: {
      'email': email,
      'password': null,
    })).called(1);
  });

  test('(GETX LOGIN PRESENTER) : Should emit email error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('(GETX LOGIN PRESENTER) : Should emit email error as null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('(GETX LOGIN PRESENTER) : Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', input: {
      'email': null,
      'password': password,
    })).called(1);
  });

  test('(GETX LOGIN PRESENTER) : Should emit password error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('(GETX LOGIN PRESENTER) : Should emit email error if validation fails', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('(GETX LOGIN PRESENTER) : Should emit required field error if validation empty', () {
    mockValidation(field: 'email', value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('(GETX LOGIN PRESENTER) : Should turn form valid on email/password error as null', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
  });

  test('(GETX LOGIN PRESENTER) : Should call authentication with correct values', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    await sut.auth();

    verify(authentication.auth(params: AuthenticationParams(email: email, password: password))).called(1);
  });

  test('(GETX LOGIN PRESENTER) : Should call save current account with correct value', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
  });

  test('(GETX LOGIN PRESENTER) : Should emit correct events on authentication success', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('(GETX LOGIN PRESENTER) : Should change page on success', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.auth();
  });

  test('(GETX LOGIN PRESENTER) : Should emit correct events on InvalidCredentials error', () async {
    mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('(GETX LOGIN PRESENTER) : Should emit correct events on Unexpected error', () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('(GETX LOGIN PRESENTER) : Should thorws Unexpected error if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(await authentication.auth(params: anyNamed('params')), AccountEntity(token: token));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('(GETX LOGIN PRESENTER) : Should go to signup on call go to signup', () async {
    sut.navigateToStream.listen(expectAsync1((page) => '/signup'));

    sut.goToSignUp();
  });
}
