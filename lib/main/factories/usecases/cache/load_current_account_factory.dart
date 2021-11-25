import '../../../../domain/usecases/load_current_account.dart';

import '../../../../data/usecases/usecases.dart';

import '../../../../main/factories/cache/local_load_storage_adapter_factory.dart';

LoadCurrentAccount makeLoadCurrentAccount() => LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeSecureCacheStorage(),
    );
