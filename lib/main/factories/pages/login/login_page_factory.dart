import 'package:app_curso_manguinho/main/factories/pages/login/login_presenter_factory.dart';
import 'package:app_curso_manguinho/ui/pages/login/login.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage() => LoginPage(makeLoginPresenter());
