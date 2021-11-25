import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorage secureStorage;
  SecureStorageAdapter sut;
  String key, value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
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
  });

  group('fetchSecure', () {
    PostExpectation mockSecureStorageCall() => when(
          secureStorage.read(key: anyNamed('key')),
        );
    void mockFetchSecureSuccess() => mockSecureStorageCall().thenAnswer((_) async => value);
    void mockFetchSecureError() => mockSecureStorageCall().thenThrow(Exception());

    setUp(() {
      mockFetchSecureSuccess();
    });

    test('Should call fetch secure with correct values', () async {
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetchSecure(key);

      expect(value, fetchedValue);
    });

    test('Should throw save secure with correct values', () async {
      mockFetchSecureError();

      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
