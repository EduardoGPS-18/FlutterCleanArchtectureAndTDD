import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/data/cache/cache.dart';

class SecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage, FetchSecureCacheStorage, DeleteSecureCacheStorage {
  SecureCacheStorageSpy() {
    mockSaveSecure();
    mockDelete();
  }

  When mockSaveSecureCall() => when(() => this.save(key: any(named: 'key'), value: any(named: 'value')));
  void mockSaveSecure() => mockSaveSecureCall().thenAnswer((_) async => _);
  void mockSaveSecureError() => mockSaveSecureCall().thenThrow(Exception());

  When mockFetchSecureCall() => when(() => this.fetch(any()));
  void mockFetchSecure(String? data) => mockFetchSecureCall().thenAnswer((_) async => data);
  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  When mockDeleteCall() => when(() => this.delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());
}
