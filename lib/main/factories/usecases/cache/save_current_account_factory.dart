import '../../../../domain/usecases/save_current_account.dart';

import '../../../../data/usecases/save_current_account/save_current_account.dart';

import '../../../../main/factories/cache/cache.dart';

SaveCurrentAccount makeSaveCurrentAccount() => LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeSaveSecureCacheStorage(),
    );
