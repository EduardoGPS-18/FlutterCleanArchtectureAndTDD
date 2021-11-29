import '../../../../domain/usecases/usecases.dart';
import '../../../../data/usecases/usecases.dart';

import '../../factories.dart';
import '../../http/authorized_http_client_decorator_factory.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) => RemoteSaveSurveyResult(
      httpClient: makeAuthorizedHttpClientDecoratorAdapter(),
      url: makeApiUrl('/surveys/$surveyId/results'),
    );
