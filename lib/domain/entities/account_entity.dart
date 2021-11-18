import 'package:meta/meta.dart';

class AccountEntity {
  final String token;

  AccountEntity({
    @required this.token,
  });

  factory AccountEntity.fromJson(Map json) =>
      AccountEntity(token: json['accessToken']);
}
