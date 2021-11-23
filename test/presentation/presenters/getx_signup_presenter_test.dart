import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/presentation/protocols/protocols.dart';

import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class AddAccountSpy extends Mock implements AddAccount {}

void main() {
  String email, name, password, confirmPassword;
  Validation validation;
  GetxSignUpPresenter sut;
  AddAccount addAccount;

  PostExpectation mockValidationCall([String field]) => when(validation.validate(
        field: field == null ? anyNamed('field') : field,
        value: anyNamed('value'),
      ));
  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    addAccount = AddAccountSpy();
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(addAccount: addAccount, validation: validation);
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    confirmPassword = faker.internet.password();
    mockValidation();
  });

  test('(GETX SIGNUP PRESENTER) : Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit email error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit email error as null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit email error if validation fails', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit null on email validation successed', () {
    mockValidation(field: 'email', value: null);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
  });

  test('(GETX SIGNUP PRESENTER) : Should call validation with correct name', () {
    sut.validateName(name);

    verify(validation.validate(field: 'name', value: name)).called(1);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit name error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit name error as null if validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit name error if validation fails', () {
    mockValidation(field: 'name', value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit null on name validation successed', () {
    mockValidation(field: 'name', value: null);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateName(name);
  });

  test('(GETX SIGNUP PRESENTER) : Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit password error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit password error as null if validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit password error if validation fails', () {
    mockValidation(field: 'password', value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit null on password validation successed', () {
    mockValidation(field: 'password', value: null);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
  });

  test('(GETX SIGNUP PRESENTER) : Should call validation with correct confirm confirmPassword', () {
    sut.validateConfirmPassword(confirmPassword);

    verify(validation.validate(field: 'confirmPassword', value: confirmPassword)).called(1);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit confirmPassword error if validation fails', () {
    mockValidation(value: ValidationError.invalidField);

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
    sut.validateConfirmPassword(confirmPassword);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit confirmPassword error as null if validation succeeds', () {
    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
    sut.validateConfirmPassword(confirmPassword);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit confirmPassword error if validation fails', () {
    mockValidation(field: 'confirmPassword', value: ValidationError.invalidField);

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('(GETX SIGNUP PRESENTER) : Should emit on confirmPassword null if validation successed1', () {
    mockValidation(field: 'confirmPassword', value: null);

    sut.confirmPasswordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1<void, bool>((isValid) => expect(isValid, false)));

    sut.validateConfirmPassword(confirmPassword);
  });

  test('(GETX SIGNUP PRESENTER) : Should enable form button if all fields are valid', () async {
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

    verify(addAccount.add(params: params)).called(1);
  });
}
