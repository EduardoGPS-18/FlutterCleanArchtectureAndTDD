import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;
  LocalSaveCurrentAccount({
    @required this.saveSecureCacheStorage,
  });
  @override
  Future<void> save(AccountEntity account) async {
    try {
      saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
    } on Exception {
      throw DomainError.unexpected;
    }
  }
}
