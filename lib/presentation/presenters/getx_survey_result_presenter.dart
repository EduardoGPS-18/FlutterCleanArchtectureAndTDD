import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/presentation/mixins/mixins.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter with SessionManager, LoadingManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  Rx<SurveyResultViewModel> _surveyResultController = Rx();
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResultController.stream;

  GetxSurveyResultPresenter({
    @required this.surveyId,
    @required this.loadSurveyResult,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResultController.value = SurveyResultViewModel.fromEntity(surveyResult);
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      }
      _surveyResultController.subject.addError(UIError.unexpected.description);
    } finally {
      isLoading = false;
    }
  }
}
