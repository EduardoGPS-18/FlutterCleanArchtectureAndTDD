import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/domain/usecases/load_surveys.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../mocks/mocks.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveys loadSurveys;
  List<SurveyEntity> surveys;

  PostExpectation mockSurveysLoadCall() => when(loadSurveys.load());
  void mockLoadSurveysData(List<SurveyEntity> list) {
    surveys = list;
    mockSurveysLoadCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() => mockSurveysLoadCall().thenThrow(DomainError.unexpected);
  void mockAccessDeniedError() => mockSurveysLoadCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveysData(FakeSurveysFactory.makeEntities());
  });

  test('Should call load surveys usecase when sut call load data', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
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
    mockLoadSurveysError();

    expectLater(
      sut.surveysDataStream,
      emitsError(UIError.unexpected.description),
    );

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    mockAccessDeniedError();

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
