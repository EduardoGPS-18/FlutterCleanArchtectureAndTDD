import '../../../../ui/pages/pages.dart';

import '../../../../presentation/presenters/presenters.dart';

import '../../factories.dart';
import '../../usecases/usecases.dart';

SignUpPresenter makeSignUpPresenter() => GetxSignUpPresenter(
      validation: makeValidationComposite(
        makeSignUpValidations(),
      ),
      saveCurrentAccount: makeSaveCurrentAccount(),
      addAccount: makeAddAccount(),
    );
