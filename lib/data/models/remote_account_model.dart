import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel({
    @required this.token,
  });

  AccountEntity toEntity() => AccountEntity(token: token);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(token: json['accessToken']);
}
