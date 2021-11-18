import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel({
    @required this.token,
  });

  AccountEntity toEntity() => AccountEntity(token: token);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) throw HttpError.invalidData;
    return RemoteAccountModel(token: json['accessToken']);
  }
}
