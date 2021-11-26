import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  Rx<bool> _isLoadingController = Rx(true);
  Stream<bool> get isLoading => _isLoadingController.stream;

  Rx<SurveyResultViewModel> _surveyResultController = Rx();
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResultController.stream;

  GetxSurveyResultPresenter({
    @required this.surveyId,
    @required this.loadSurveyResult,
  });

  Future<void> loadData() async {
    try {
      _isLoadingController.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResultController.value = SurveyResultViewModel.fromEntity(surveyResult);
    } catch (error) {
      _surveyResultController.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoadingController.value = false;
    }
  }
}
