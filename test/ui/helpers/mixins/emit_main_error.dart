import 'dart:async';

import 'package:app_curso_manguinho/ui/helpers/helpers.dart';

mixin EmitMainError {
  final mainErrorController = StreamController<UIError?>();
  void emitMainError(UIError error) => mainErrorController.add(error);
}
