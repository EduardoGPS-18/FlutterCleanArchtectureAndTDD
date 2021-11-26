import '../../../../domain/usecases/load_surveys.dart';

import '../../../../data/usecases/load_surveys/load_surveys.dart';

import '../../../composites/composites.dart';

import '../../http/authorized_http_client_decorator_factory.dart';
import '../../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizedHttpClientDecoratorAdapter(),
      url: makeApiUrl('/surveys'),
    );

LocalLoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(
      cacheStorage: makeLocalStorageAdapter(),
    );

RemoteLoadSurveysWithLocalFallback makeRemoteLoadSurveysWithLocalFallback() => RemoteLoadSurveysWithLocalFallback(
      local: makeLocalLoadSurveys(),
      remote: makeRemoteLoadSurveys(),
    );
