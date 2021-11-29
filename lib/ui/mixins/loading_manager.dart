import 'package:flutter/material.dart';

import '../components/components.dart';

mixin LoadingManager {
  void handleLoading({@required BuildContext context, @required Stream<bool> stream}) {
    stream.listen(
      (isLoading) {
        if (isLoading == true) {
          showLoading(context);
        } else {
          hideLoading(context);
        }
      },
    );
  }
}
