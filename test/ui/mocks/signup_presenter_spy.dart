import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/helpers.dart';

import '../helpers/helpers.dart';

class SignUpPresenterSpy extends Mock with EmitLoading, EmitNavigateTo, EmitMainError, EmitFormStatus implements SignUpPresenter {
  final nameErrorController = StreamController<UIError?>();
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final passwordConfirmationErrorController = StreamController<UIError?>();

  SignUpPresenterSpy() {
    when(() => this.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => this.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => this.mainErrorStream).thenAnswer((_) => mainErrorController.stream);

    when(() => this.nameErrorStream).thenAnswer((_) => nameErrorController.stream);
    when(() => this.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => this.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => this.confirmPasswordErrorStream).thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void emitNameError(UIError error) => nameErrorController.add(error);
  void emitNameValid() => nameErrorController.add(null);

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);

  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);

  void emitConfirmPasswordValid() => passwordConfirmationErrorController.add(null);
  void emitConfirmPasswordError(UIError error) => passwordConfirmationErrorController.add(error);

  void dispose() {
    isLoadingController.close();
    nameErrorController.close();
    mainErrorController.close();
    emailErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }
}
