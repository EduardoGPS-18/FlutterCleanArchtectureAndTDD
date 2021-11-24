import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;
  StreamController<bool> isLoadingController;
  StreamController<List<SurveyViewModel>> surveysDataController;

  void initStreams() {
    isLoadingController = StreamController();
    surveysDataController = StreamController();
  }

  void mockStreams() {
    when(presenter.isLoading).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysDataStream).thenAnswer((_) => surveysDataController.stream);
  }

  void closeStreams() {
    surveysDataController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(
            presenter: presenter,
          ),
        ),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
        SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
      ];

  tearDown(closeStreams);

  testWidgets('Should call load surveys on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should show loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should presents error message if surveys data has error', (WidgetTester tester) async {
    await loadPage(tester);

    surveysDataController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should presents list if surveys has data', (WidgetTester tester) async {
    await loadPage(tester);

    surveysDataController.add(makeSurveys());
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call load surveys on reload button click', (WidgetTester tester) async {
    await loadPage(tester);

    surveysDataController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(presenter.loadData()).called(2);
  });
}
