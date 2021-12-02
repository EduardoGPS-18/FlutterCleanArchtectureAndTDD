import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required AuthenticationParams params});
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
