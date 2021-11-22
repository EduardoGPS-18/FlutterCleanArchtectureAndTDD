import '../../../../main/factories/cache/cache.dart';

import '../../../../domain/usecases/save_current_account.dart';

import '../../../../data/usecases/save_current_account/save_current_account.dart';

SaveCurrentAccount makeSaveCurrentAccount() => LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeSaveSecureCacheStorage(),
    );
