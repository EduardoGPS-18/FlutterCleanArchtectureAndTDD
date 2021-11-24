import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  RxBool _isLoadingController = RxBool(true);
  Stream<bool> get isLoading => _isLoadingController.stream;

  Rx<List<SurveyViewModel>> _surveysDataController = Rx();
  Stream<List<SurveyViewModel>> get surveysDataStream => _surveysDataController.stream;

  GetxSurveysPresenter({
    @required this.loadSurveys,
  });

  Future<void> loadData() async {
    try {
      _isLoadingController.value = true;
      final surveys = await loadSurveys.load();
      _surveysDataController.value = surveys.map((e) => SurveyViewModel.fromEntity(e)).toList();
    } on DomainError {
      _surveysDataController.subject.addError(UIError.unexpected.description, StackTrace.empty);
    } finally {
      _isLoadingController.value = false;
    }
  }
}
