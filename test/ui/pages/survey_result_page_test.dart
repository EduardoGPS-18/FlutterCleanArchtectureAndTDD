import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/pages.dart';
import 'package:app_curso_manguinho/ui/helpers/helpers.dart';
import 'package:app_curso_manguinho/ui/pages/survey_result/components/components.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    final surveysPage = makePage(
      path: '/survey_result/any_survey_id',
      page: () => SurveyResultPage(
        presenter: presenter,
      ),
    );
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  tearDown(() => presenter.dispose());

  testWidgets('Should call load surveys on page load', (tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should presents error message if surveys data has error', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();
    expect(find.text(UIError.unexpected.description), findsOneWidget);
    expect(find.text(R.strings.reload), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call load surveys on reload button click', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(R.strings.reload));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('Should presents valid data if survey result screen success ', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());

    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text(UIError.unexpected.description), findsNothing);
    expect(find.text(R.strings.reload), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('30%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(InactiveIcon), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

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

      expect(currentPage, '/survey_result/any_survey_id');
      expect(find.text('fake login'), findsNothing);
    },
  );

  testWidgets('Should call save on list item click', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 1'));

    verify(() => presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('Should not call save on current answer click', (tester) async {
    await loadPage(tester);

    presenter.emitSurveyResult(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    await tester.tap(find.text('Answer 0'));

    verifyNever(() => presenter.save(answer: 'Answer 0'));
  });
}
