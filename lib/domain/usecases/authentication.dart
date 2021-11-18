import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({@required AuthenticationParams authParams});
}

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    @required this.email,
    @required this.password,
  });
}
