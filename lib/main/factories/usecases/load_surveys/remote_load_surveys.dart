import '../../../../data/usecases/usecases.dart';
import '../../../composites/composites.dart';

import '../../http/http.dart';
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
