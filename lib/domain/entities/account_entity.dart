import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String token;

  AccountEntity({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}
