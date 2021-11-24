import 'package:flutter/material.dart';

import 'surveys_presenter_factory.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSurveysPage() => SurveysPage(
      presenter: makeSurveysPresenter(),
    );
