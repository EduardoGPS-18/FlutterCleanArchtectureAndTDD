import 'package:flutter/material.dart';

import '../../../../ui/pages/splash/splash_page.dart';

import '../../../../main/factories/pages/splash/splash.dart';

Widget makeSplashPage() => SplashPage(presenter: makeGetxSplashPresenter());
