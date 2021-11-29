import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/presentation/mixins/mixins.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager, LoadingManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  Rx<SurveyResultViewModel> _surveyResultController = Rx();
  Stream<SurveyResultViewModel> get surveyResultStream => _surveyResultController.stream;

  GetxSurveyResultPresenter({
    @required this.saveSurveyResult,
    @required this.surveyId,
    @required this.loadSurveyResult,
  });

  Future<void> loadData() async {
    await _showResultOnAction(() async => await loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({@required String answer}) async {
    await _showResultOnAction(() async => await saveSurveyResult.save(answer: answer));
  }

  Future<void> _showResultOnAction(Future<SurveyResultEntity> Function() action) async {
    try {
      isLoading = true;
      final surveyResult = await action();
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
