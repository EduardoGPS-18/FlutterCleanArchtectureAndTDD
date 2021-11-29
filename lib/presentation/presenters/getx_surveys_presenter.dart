import 'package:app_curso_manguinho/presentation/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

class GetxSurveysPresenter extends GetxController with LoadingManager, SessionManager, NavigateManager implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  Rx<List<SurveyViewModel>> _surveysDataController = Rx();
  Stream<List<SurveyViewModel>> get surveysDataStream => _surveysDataController.stream;

  GetxSurveysPresenter({
    @required this.loadSurveys,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveysDataController.value = surveys.map((e) => SurveyViewModel.fromEntity(e)).toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      }

      _surveysDataController.subject.addError(UIError.unexpected.description, StackTrace.empty);
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    navigateTo = '/survey_result/$surveyId';
  }
}
