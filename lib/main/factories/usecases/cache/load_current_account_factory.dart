import '../../../../domain/usecases/load_current_account.dart';

import '../../../../data/usecases/usecases.dart';

import '../../cache/cache.dart';

LoadCurrentAccount makeLoadCurrentAccount() => LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
    );
