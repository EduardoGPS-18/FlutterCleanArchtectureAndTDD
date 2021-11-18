import 'package:meta/meta.dart';

import '../../domain/domain.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    @required String name,
    @required String email,
  });
}
