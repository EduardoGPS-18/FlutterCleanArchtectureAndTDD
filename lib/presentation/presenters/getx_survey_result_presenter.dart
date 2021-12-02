import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/domain_error.dart';

import '../mixins/mixins.dart';
import '../helpers/helpers.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager, LoadingManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  Rx<SurveyResultViewModel?> _surveyResultController = Rx(null);
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResultController.stream;

  GetxSurveyResultPresenter({
    required this.surveyId,
    required this.saveSurveyResult,
    required this.loadSurveyResult,
  });

  Future<void> loadData() async {
    await _showResultOnAction(() async => await loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  @override
  Future<void> save({required String answer}) async {
    await _showResultOnAction(() async => await saveSurveyResult.save(answer: answer));
  }

  Future<void> _showResultOnAction(Future<SurveyResultEntity> Function() action) async {
    try {
      isLoading = true;
      final surveyResult = await action();
      _surveyResultController.subject.add(surveyResult.toViewModel());
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
