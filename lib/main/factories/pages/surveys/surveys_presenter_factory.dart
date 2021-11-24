import '../../../../presentation/presenters/presenters.dart';

import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

SurveysPresenter makeSurveysPresenter() => GetxSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveys(),
    );
