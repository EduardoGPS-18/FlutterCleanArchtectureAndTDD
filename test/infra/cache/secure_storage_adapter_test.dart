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
      await sut.save(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('Should throw save secure with correct values', () async {
      mockSecureStorageError();

      final future = sut.save(key: key, value: value);

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
      await sut.fetch(key);

      verify(secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(value, fetchedValue);
    });

    test('Should throw save secure with correct values', () async {
      mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    PostExpectation mockSecureStorageCall() => when(
          secureStorage.delete(key: anyNamed('key')),
        );
    void mockDeleteSecureCacheError() => mockSecureStorageCall().thenThrow(Exception());
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key: key)).called(1);
    });

    test('Should throws if delete item throws', () async {
      mockDeleteSecureCacheError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
