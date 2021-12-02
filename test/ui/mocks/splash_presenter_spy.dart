import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class SplashPresenterSpy extends Mock with EmitNavigateTo implements SplashPresenter {
  SplashPresenterSpy() {
    when(() => checkCurrentAccount(durationInSeconds: any(named: 'durationInSeconds'))).thenAnswer((_) async => _);
    when(() => this.navigateToStream).thenAnswer((_) => navigateToController.stream);
  }

  void dispose() {
    navigateToController.close();
  }
}
