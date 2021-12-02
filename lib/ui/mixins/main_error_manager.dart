import 'package:flutter/material.dart';

import '../helpers/helpers.dart';
import '../components/components.dart';

mixin MainErrorManager {
  void handleMainError({required Stream<UIError?> stream, required BuildContext context}) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context: context, error: error.description);
      }
    });
  }
}
