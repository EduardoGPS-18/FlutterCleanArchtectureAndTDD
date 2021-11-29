import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../components/components.dart';

mixin MainErrorManager {
  void handleMainError({@required Stream<UIError> stream, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(scaffoldKey: scaffoldKey, error: error.description);
      }
    });
  }
}
