import 'dart:async';

mixin EmitNavigateTo {
  final navigateToController = StreamController<String>();
  void emitNavigateTo(String route) => navigateToController.add(route);
}
