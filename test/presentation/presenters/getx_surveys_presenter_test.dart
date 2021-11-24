import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/helpers/domain_error.dart';
import 'package:app_curso_manguinho/domain/usecases/load_surveys.dart';

import 'package:app_curso_manguinho/presentation/presenters/presenters.dart';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveys loadSurveys;

  List<SurveyEntity> validSurveysData = [
    SurveyEntity(
      dateTime: DateTime(2020, 2, 20),
      didAnswer: faker.randomGenerator.boolean(),
      id: faker.guid.guid(),
      question: faker.lorem.sentence(),
    ),
    SurveyEntity(
      dateTime: DateTime(2018, 10, 3),
      didAnswer: faker.randomGenerator.boolean(),
      id: faker.guid.guid(),
      question: faker.lorem.sentence(),
    ),
  ];

  PostExpectation mockSurveysLoadCall() => when(loadSurveys.load());
  void mockLoadSurveysData(List<SurveyEntity> mockedList) => mockSurveysLoadCall().thenAnswer(
        (_) async => mockedList,
      );
  void mockLoadSurveysError() => mockSurveysLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveysData(validSurveysData);
  });

  test('Should call load surveys usecase when sut call load data', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Is loading controller should emits true before call usecase method and hide on method end', () async {
    expectLater(sut.isLoading, emitsInOrder([true, false]));

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    sut.surveysData.listen(
      expectAsync1(
        (data) => expect(data, [
          SurveyViewModel(
            date: DateFormat("dd MMM yyyy").format(validSurveysData[0].dateTime),
            didAnswer: validSurveysData[0].didAnswer,
            id: validSurveysData[0].id,
            question: validSurveysData[0].question,
          ),
          SurveyViewModel(
            date: DateFormat("dd MMM yyyy").format(validSurveysData[1].dateTime),
            didAnswer: validSurveysData[1].didAnswer,
            id: validSurveysData[1].id,
            question: validSurveysData[1].question,
          ),
        ]),
      ),
    );

    await sut.loadData();
  });

  test('Should notify surveysData with converted to viewmodel data when usecase has valid data', () async {
    mockLoadSurveysError();

    expectLater(
      sut.surveysData,
      emitsError(UIError.unexpected.description),
    );

    await sut.loadData();
  });
}
