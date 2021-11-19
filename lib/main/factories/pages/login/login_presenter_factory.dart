import 'package:app_curso_manguinho/main/factories/pages/login/login_validation_factory.dart';
import 'package:app_curso_manguinho/main/factories/usecases/usecases.dart';
import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';
import 'package:app_curso_manguinho/ui/pages/login/login.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      validation: makeValidationComposite(),
      authenticationUsecase: makeRemoteAuthentication(),
    );
