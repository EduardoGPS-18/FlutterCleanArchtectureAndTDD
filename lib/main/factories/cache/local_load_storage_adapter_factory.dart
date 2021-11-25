import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../data/cache/cache.dart';

import '../../../infra/cache/cache.dart';

FetchSecureCacheStorage makeSecureCacheStorage() => SecureStorageAdapter(
      secureStorage: FlutterSecureStorage(),
    );
