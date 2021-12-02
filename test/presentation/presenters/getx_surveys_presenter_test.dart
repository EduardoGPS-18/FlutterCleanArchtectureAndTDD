import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    surveys = EntityFactory.makeSurveys();
    loadSurveys.mockLoadSurveys(surveys);
  });

  test('Should call load surveys usecase when sut call load data', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('Is loading controller should emits true before call usecase method and hide on method end', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    sut.surveysDataStream.listen(
      expectAsync1(
        (data) => expect(data, [
          SurveyViewModel(
            date: "25 Feb 2018",
            didAnswer: false,
            id: surveys[0].id,
            question: surveys[0].question,
          ),
          SurveyViewModel(
            date: "27 Apr 2020",
            didAnswer: true,
            id: surveys[1].id,
            question: surveys[1].question,
          ),
        ]),
      ),
    );

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    loadSurveys.mockLoadSurveysError(DomainError.unexpected);

    expectLater(
      sut.surveysDataStream,
      emitsError(UIError.unexpected.description),
    );

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    loadSurveys.mockLoadSurveysError(DomainError.accessDenied);

    expectLater(
      sut.isLoadingStream,
      emitsInOrder([true, false]),
    );
    expectLater(
      sut.isSessionExpiredStream,
      emits(true),
    );

    await sut.loadData();
  });

  test('Should go to survey result page on call go to survey result', () async {
    expectLater(
      sut.navigateToStream,
      emitsInOrder([
        '/survey_result/any_route',
        '/survey_result/any_route',
      ]),
    );

    sut.goToSurveyResult('any_route');
    sut.goToSurveyResult('any_route');
  });
}
