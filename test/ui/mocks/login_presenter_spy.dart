import 'dart:async';
import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:app_curso_manguinho/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class LoginPresenterSpy extends Mock with EmitLoading, EmitNavigateTo, EmitMainError, EmitFormStatus implements LoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();

  LoginPresenterSpy() {
    when(() => this.auth()).thenAnswer((_) async => _);

    when(() => this.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => this.emailErrorStream).thenAnswer((_) => emailErrorController.stream);

    when(() => this.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    when(() => this.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => this.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);

  void dispose() {
    isLoadingController.close();
    mainErrorController.close();
    isLoadingController.close();
    emailErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    passwordErrorController.close();
  }
}
