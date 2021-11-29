import '../../../../domain/usecases/load_surveys_result.dart';

import '../../../../data/usecases/usecases.dart';

import '../../factories.dart';
import '../../../composites/composites.dart';
import '../../http/authorized_http_client_decorator_factory.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
      httpClient: makeAuthorizedHttpClientDecoratorAdapter(),
      url: makeApiUrl('/surveys/$surveyId/results'),
    );

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) => LocalLoadSurveyResult(
      cacheStorage: makeLocalStorageAdapter(),
    );

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId),
  );
}
