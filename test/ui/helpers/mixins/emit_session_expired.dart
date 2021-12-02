import 'dart:async';

mixin EmitSessionExpired {
  final isSessionExpiredController = StreamController<bool>();
  void emitSessionExpired([bool expired = true]) => isSessionExpiredController.add(expired);
}
