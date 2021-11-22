import 'package:flutter/material.dart';

import '../../../../ui/pages/login/login.dart';

import '../../../../main/factories/pages/login/login.dart';

Widget makeLoginPage() => LoginPage(makeGetxLoginPresenter());
