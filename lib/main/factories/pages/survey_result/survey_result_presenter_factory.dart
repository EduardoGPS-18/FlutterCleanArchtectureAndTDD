import '../../usecases/usecases.dart';

import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/pages.dart';

SurveyResultPresenter makeSurveyResultPresenter(String surveyId) => GetxSurveyResultPresenter(
      loadSurveyResult: makeRemoteLoadSurveyResult(surveyId),
      surveyId: surveyId,
    );
