import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../../data/cache/cache.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;
  LocalSaveCurrentAccount({
    required this.saveSecureCacheStorage,
  });
  @override
  Future<void> save(AccountEntity account) async {
    try {
      saveSecureCacheStorage.save(key: 'token', value: account.token);
    } on Exception {
      throw DomainError.unexpected;
    }
  }
}
