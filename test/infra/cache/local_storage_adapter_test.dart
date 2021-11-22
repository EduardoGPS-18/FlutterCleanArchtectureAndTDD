import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

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

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorage secureStorage;
  LocalStorageAdapter sut;
  String key, value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  PostExpectation mockSecureStorageCall() => when(
        secureStorage.write(key: anyNamed('key'), value: anyNamed('value')),
      );
  void mockSecureStorageError() => mockSecureStorageCall().thenThrow(Exception());

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(secureStorage.write(key: key, value: value));
  });

  test('Should throw save secure with correct values', () async {
    mockSecureStorageError();

    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
