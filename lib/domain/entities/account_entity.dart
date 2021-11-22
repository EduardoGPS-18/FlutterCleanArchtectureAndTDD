import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AccountEntity extends Equatable {
  final String token;

  AccountEntity({
    @required this.token,
  });

  @override
  List<Object> get props => [token];
}
