import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/splash/splash.dart';

import '../../../../main/factories/usecases/cache/load_current_account_factory.dart';

SplashPresenter makeGetxSplashPresenter() => GetxSplashPresenter(
      loadCurrentAccount: makeLoadCurrentAccount(),
    );
