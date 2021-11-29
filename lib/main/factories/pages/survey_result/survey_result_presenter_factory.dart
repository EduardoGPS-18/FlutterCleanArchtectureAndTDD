import '../../usecases/usecases.dart';

import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/pages.dart';

SurveyResultPresenter makeSurveyResultPresenter(String surveyId) => GetxSurveyResultPresenter(
      loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
      surveyId: surveyId,
    );
