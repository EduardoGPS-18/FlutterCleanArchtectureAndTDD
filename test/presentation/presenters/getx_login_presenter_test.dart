import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late String email;
  late String password;
  late LoginPresenter sut;
  late AccountEntity account;
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late SaveCurrentAccountSpy saveCurrentAccount;

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxLoginPresenter(
      validation: validation,
      authenticationUsecase: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );

    email = faker.internet.email();
    password = faker.internet.password();
    account = EntityFactory.makeAccount();
    authentication.mockAuthentication(account);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAuthentication());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', input: {
          'email': email,
          'password': null,
        })).called(1);
  });

  test('Should emit email error if validation fails', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit email error as null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: {
          'email': null,
          'password': password,
        })).called(1);
  });

  test('Should emit password error if validation fails', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit email error if validation fails', () {
    validation.mockValidationError(field: 'email', value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('Should emit required field error if validation empty', () {
    validation.mockValidationError(field: 'email', value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('Should turn form valid on email/password error as null', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
  });

  test('Should call authentication with correct values', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    await sut.auth();

    verify(() => authentication.auth(params: AuthenticationParams(email: email, password: password))).called(1);
  });

  test('Should call save current account with correct value', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    await sut.auth();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('Should emit correct events on authentication success', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test('Should change page on success', () async {
    sut.validatePassword(password);
    sut.validateEmail(email);

    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentials error', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.invalidCredentials]));
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on Unexpected error', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should thorws Unexpected error if SaveCurrentAccount fails', () async {
    saveCurrentAccount.mockSaveCurrentAccountError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(await authentication.auth(params: AuthenticationParams(email: email, password: password)), account);
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.auth();
  });

  test('Should go to signup on call go to signup', () async {
    sut.navigateToStream.listen(expectAsync1((page) => '/signup'));

    sut.goToSignUp();
  });
}
