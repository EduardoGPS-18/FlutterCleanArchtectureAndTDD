import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/splash/splash.dart';

import '../../../../main/factories/usecases/cache/cache.dart';

SplashPresenter makeGetxSplashPresenter() => GetxSplashPresenter(
      loadCurrentAccount: makeLoadCurrentAccount(),
    );
