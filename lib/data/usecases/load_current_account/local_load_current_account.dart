import '../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({
    required this.fetchSecureCacheStorage,
  });

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');

      if (token == null) throw Exception();

      return AccountEntity(token: token);
    } on Exception {
      throw DomainError.unexpected;
    }
  }
}
