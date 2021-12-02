import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:app_curso_manguinho/ui/pages/splash/splash.dart';

import '../helpers/helpers.dart';
import '../mocks/splash_presenter_spy.dart';

void main() {
  late SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    await tester.pumpWidget(makePage(path: '/', page: () => SplashPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('Should presents spinner on page load', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call load current account on page load', (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.checkCurrentAccount(durationInSeconds: 2)).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentPage, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
    verify(() => presenter.checkCurrentAccount(durationInSeconds: 2)).called(1);
  });

  testWidgets('Should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();
    expect(currentPage, '/');
  });
}
