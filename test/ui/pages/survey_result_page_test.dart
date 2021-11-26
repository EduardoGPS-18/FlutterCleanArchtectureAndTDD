import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  SurveyResultPresenter presenter;

  StreamController<bool> isLoadingController;
  StreamController<dynamic> surveysDataController;

  void initStreams() {
    surveysDataController = StreamController();
    isLoadingController = StreamController();
  }

  void mockStreams() {
    when(presenter.isLoading).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysData).thenAnswer((_) => surveysDataController.stream);
  }

  void closeStreams() {
    surveysDataController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    mockStreams();
    initStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
          name: '/survey_result/:any_survey_id',
          page: () => SurveyResultPage(
            presenter: presenter,
          ),
        ),
      ],
    );
    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  tearDown(closeStreams);

  testWidgets('Should call load surveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should presents error message if surveys data has error', (WidgetTester tester) async {
    await loadPage(tester);

    surveysDataController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
  });
}
