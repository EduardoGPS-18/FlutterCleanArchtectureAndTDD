import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:app_curso_manguinho/ui/helpers/errors/errors.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveysPresenterSpy presenter;

  Future<void> loadPage(tester) async {
    presenter = SurveysPresenterSpy();

    final surveysPage = makePage(page: () => SurveysPage(presenter: presenter), path: '/surveys');
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() => presenter.dispose());

  testWidgets('Should call load surveys on page load', (tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should call load surveys on reload', (tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should show loading', (tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should presents error message if surveys data has error', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should presents list if surveys has data', (tester) async {
    await loadPage(tester);

    presenter.emitSurveys(ViewModelFactory.makeSurveys());
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

    presenter.emitSurveyError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets(
    'Should call go to survey result on survey click',
    (tester) async {
      await loadPage(tester);

      final surveys = ViewModelFactory.makeSurveys();
      presenter.emitSurveys(surveys);
      await tester.pump();

      final button = find.text(surveys[0].question);
      await tester.tap(button);

      verify(() => presenter.goToSurveyResult(surveys[0].id)).called(1);
    },
  );

  testWidgets(
    'Should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitNavigateTo('/any_route');
      await tester.pumpAndSettle();

      expect(currentPage, '/any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    'Should logout',
    (tester) async {
      await loadPage(tester);

      presenter.emitSessionExpired();
      await tester.pumpAndSettle();

      expect(currentPage, '/login');
      expect(find.text('fake login'), findsOneWidget);
    },
  );

  testWidgets(
    'Should not logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      presenter.emitSessionExpired(false);
      await tester.pumpAndSettle();

      expect(currentPage, '/surveys');
      expect(find.text('fake login'), findsNothing);
    },
  );
}
