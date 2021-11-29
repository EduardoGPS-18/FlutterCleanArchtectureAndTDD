import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/domain/usecases/load_surveys_result.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final LoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
  });

  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  String surveyId;
  LoadSurveyResult remote;
  RemoteLoadSurveyResultWithLocalFallback sut;

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote);
  });

  test('Should call remote load by survey', () async {
    sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
