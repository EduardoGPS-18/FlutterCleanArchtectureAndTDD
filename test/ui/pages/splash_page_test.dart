import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';

import '../helpers/helpers.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenter presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController();

    when(presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);

    await tester.pumpWidget(makePage(path: '/', page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should presents spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call load current account on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.checkCurrentAccount()).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentPage, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
    verify(presenter.checkCurrentAccount()).called(1);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentPage, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentPage, '/');
  });
}
