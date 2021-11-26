import 'package:app_curso_manguinho/data/usecases/load_survey_result/load_survey_result.dart';
import 'package:app_curso_manguinho/domain/usecases/load_surveys_result.dart';
import 'package:app_curso_manguinho/main/factories/factories.dart';
import 'package:app_curso_manguinho/main/factories/http/authorized_http_client_decorator_factory.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) => RemoteLoadSurveyResult(
      httpClient: makeAuthorizedHttpClientDecoratorAdapter(),
      url: makeApiUrl('/surveys/$surveyId/results'),
    );
