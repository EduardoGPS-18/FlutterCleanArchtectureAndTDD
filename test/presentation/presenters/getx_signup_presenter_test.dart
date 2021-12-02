import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';
import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../domain/mocks/mocks.dart';
import '../mocks/mocks.dart';

void main() {
  late AccountEntity account;
  late ValidationSpy validation;
  late AddAccountSpy addAccount;
  late GetxSignUpPresenter sut;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late String email, name, password, confirmPassword;

  setUp(() {
    addAccount = AddAccountSpy();
    validation = ValidationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      addAccount: addAccount,
      validation: validation,
      saveCurrentAccount: saveCurrentAccount,
    );

    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    confirmPassword = faker.internet.password();

    account = EntityFactory.makeAccount();
    addAccount.mockAddAccount(account);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeAccount());
    registerFallbackValue(ParamsFactory.makeAddAccount());
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', input: {
          'name': null,
          'email': email,
          'password': null,
          'confirmPassword': null,
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

  test('Should emit email error if validation fails', () {
    validation.mockValidationError(field: 'email', value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
  });

  test('Should emit null on email validation successed', () {
    validation.mockValidation(field: 'email');

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
  });

  test('Should call validation with correct name', () {
    sut.validateName(name);

    verify(() => validation.validate(field: 'name', input: {
          'name': name,
          'email': null,
          'password': null,
          'confirmPassword': null,
        })).called(1);
  });

  test('Should emit name error if validation fails', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit name error as null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit name error if validation fails', () {
    validation.mockValidationError(field: 'name', value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test('Should emit null on name validation successed', () {
    validation.mockValidation(field: 'name');

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', input: {
          'name': null,
          'email': null,
          'password': password,
          'confirmPassword': null,
        })).called(1);
  });

  test('Should emit password error if validation fails', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error as null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    validation.mockValidationError(field: 'password', value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('Should emit null on password validation successed', () {
    validation.mockValidation(field: 'password');

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('Should call validation with correct confirm confirmPassword', () {
    sut.validateConfirmPassword(confirmPassword);

    verify(() => validation.validate(field: 'confirmPassword', input: {
          'name': null,
          'email': null,
          'password': null,
          'confirmPassword': confirmPassword,
        })).called(1);
  });

  test('Should emit confirmPassword error if validation fails', () {
    validation.mockValidationError(value: ValidationError.invalidField);

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should emit confirmPassword error as null if validation succeeds', () {
    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should emit confirmPassword error if validation fails', () {
    validation.mockValidationError(field: 'confirmPassword', value: ValidationError.invalidField);

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should emit on confirmPassword null if validation successed1', () {
    validation.mockValidation(field: 'confirmPassword');

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('Should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validateConfirmPassword(confirmPassword);
    await Future.delayed(Duration.zero);
  });

  test('Should call add account with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    await sut.signUp();
    final params = AddAccountParams(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
    );

    verify(() => addAccount.add(params: params)).called(1);
  });

  test('Should return account entity on usecase call success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    final account = await sut.signUp();

    expect(account, account);
  });

  test('Should call save current account with correct value', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    await sut.signUp();

    verify(() => saveCurrentAccount.save(account));
  });

  test('Should emit unexpected error if save current account fails', () async {
    addAccount.mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expect(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    await sut.signUp();
  });

  test('Should emit correct events on add account success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expect(sut.isLoadingStream, emits(true));

    await sut.signUp();
  });

  test('Should emit correct events on email in use error', () async {
    addAccount.mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expect(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();
  });

  test('Should emit correct events on unexpected error', () async {
    addAccount.mockAddAccountError(DomainError.unexpected);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    expect(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateConfirmPassword(confirmPassword);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('Should go to login page on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.goToLogin();
  });
}
