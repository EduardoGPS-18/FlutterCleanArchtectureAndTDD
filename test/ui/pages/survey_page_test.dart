import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../../mocks/mocks.dart';
import '../helpers/helpers.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;
  StreamController<bool> isLoadingController;
  StreamController<String> navigateToController;
  StreamController<bool> isSessionExpiredController;
  StreamController<List<SurveyViewModel>> surveysDataController;

  void initStreams() {
    navigateToController = StreamController();
    isSessionExpiredController = StreamController();
    isLoadingController = StreamController();
    surveysDataController = StreamController();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysDataStream).thenAnswer((_) => surveysDataController.stream);
    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(presenter.isSessionExpiredStream).thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    surveysDataController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
    navigateToController.close();
  }

  Future<void> loadPage(tester) async {
    presenter = SurveysPresenterSpy();

    mockStreams();
    initStreams();

    final surveysPage = makePage(page: () => SurveysPage(presenter: presenter), path: '/surveys');
    await tester.pumpWidget(surveysPage);
  }

  tearDown(closeStreams);

  testWidgets('Should call load surveys on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should call load surveys on reload', (tester) async {
    await loadPage(tester);

    navigateToController.add('any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should show loading', (tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (tester) async {
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

  testWidgets('Should presents error message if surveys data has error', (tester) async {
    await loadPage(tester);

    surveysDataController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should presents list if surveys has data', (tester) async {
    await loadPage(tester);

    surveysDataController.add(FakeSurveysFactory.makeViewModel());
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call load surveys on reload button click', (tester) async {
    await loadPage(tester);

    surveysDataController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets(
    'Should call go to survey result on survey click',
    (tester) async {
      await loadPage(tester);

      final surveys = FakeSurveysFactory.makeViewModel();
      surveysDataController.add(surveys);
      await tester.pump();

      final button = find.text(surveys[0].question);
      await tester.tap(button);

      verify(presenter.goToSurveyResult(surveys[0].id)).called(1);
    },
  );

  testWidgets(
    'Should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('/any_route');
      await tester.pumpAndSettle();

      expect(currentPage, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    'Should logout',
    (tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(true);
      await tester.pumpAndSettle();

      expect(currentPage, '/login');
      expect(find.text('fake login'), findsOneWidget);
    },
  );

  testWidgets(
    'Should not logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(false);
      await tester.pumpAndSettle();
      isSessionExpiredController.add(null);
      await tester.pumpAndSettle();

      expect(currentPage, '/surveys');
      expect(find.text('fake login'), findsNothing);
    },
  );
}
