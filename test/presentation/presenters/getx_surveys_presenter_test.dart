import 'dart:async';
import 'package:meta/meta.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/usecases/load_surveys.dart';

class GetxSurveysPresenter extends GetxController {
  LoadSurveys loadSurveys;

  GetxSurveysPresenter({
    @required this.loadSurveys,
  });

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  test('Should call load surveys usecase when sut call load data', () async {
    final loadSurveys = LoadSurveysSpy();
    final sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });
}
