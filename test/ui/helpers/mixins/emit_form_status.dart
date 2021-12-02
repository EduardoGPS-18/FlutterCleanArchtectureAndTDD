import 'dart:async';

mixin EmitFormStatus {
  final isFormValidController = StreamController<bool>();
  void emitInvalidForm() => isFormValidController.add(false);
  void emitValidForm() => isFormValidController.add(true);
}
