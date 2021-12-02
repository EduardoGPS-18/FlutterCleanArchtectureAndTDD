import 'dart:async';

mixin EmitLoading {
  final isLoadingController = StreamController<bool>();
  void emitLoading([bool show = true]) => isLoadingController.add(show);
}
