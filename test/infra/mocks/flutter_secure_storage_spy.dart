import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {
  FlutterSecureStorageSpy() {
    mockSaveStorage();
    mockDeleteSecure();
  }

  When mockSecureStorageWriteCall() => when(
        () => write(key: any(named: 'key'), value: any(named: 'value')),
      );
  void mockSaveStorage() => mockSecureStorageWriteCall().thenAnswer((_) async => _);
  void mockSaveStorageError() => mockSecureStorageWriteCall().thenThrow(Exception());

  When mockSecureReadStorageCall() => when(() => read(key: any(named: 'key')));
  void mockFetchSecure<T>(T data) => mockSecureReadStorageCall().thenAnswer((_) async => data);
  void mockFetchSecureError() => mockSecureReadStorageCall().thenThrow(Exception());

  When mockSecureStorageCall() => when(() => delete(key: any(named: 'key')));
  void mockDeleteSecure() => mockSecureStorageCall().thenAnswer((_) async => _);
  void mockDeleteSecureError() => mockSecureStorageCall().thenThrow(Exception());
}
