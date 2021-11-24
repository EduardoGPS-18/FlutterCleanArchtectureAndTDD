import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/login/login.dart';

import '../../factories.dart';
import '../../../../main/factories/pages/login/login.dart';
import '../../../../main/factories/usecases/usecases.dart';

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      validation: makeValidationComposite(
        makeLoginValidations(),
      ),
      authenticationUsecase: makeRemoteAuthentication(),
      saveCurrentAccount: makeSaveCurrentAccount(),
    );
