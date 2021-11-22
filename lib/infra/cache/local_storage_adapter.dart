import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  FlutterSecureStorage secureStorage;

  LocalStorageAdapter({
    @required this.secureStorage,
  });

  Future<void> saveSecure({@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}
