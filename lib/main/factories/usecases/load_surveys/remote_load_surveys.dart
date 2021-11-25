import 'package:app_curso_manguinho/main/factories/http/authorized_http_client_decorator_factory.dart';

import '../../../../domain/usecases/load_surveys.dart';

import '../../../../data/usecases/load_surveys/load_surveys.dart';

import '../../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizedHttpClientDecoratorAdapter(),
      url: makeApiUrl('/surveys'),
    );
