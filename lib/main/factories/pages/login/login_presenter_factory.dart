import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/login/login.dart';

import '../../../../main/factories/pages/login/login.dart';
import '../../../../main/factories/usecases/usecases.dart';

LoginPresenter makeStreamLoginPresenter() => StreamLoginPresenter(
      validation: makeValidationComposite(),
      authenticationUsecase: makeRemoteAuthentication(),
    );

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      validation: makeValidationComposite(),
      authenticationUsecase: makeRemoteAuthentication(),
    );
