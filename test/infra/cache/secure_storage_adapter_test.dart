import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {
  late String key, value;
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();

    secureStorage.mockFetchSecure(value);
  });

  group('saveSecure', () {
    test('Should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('Should throw save secure with correct values', () async {
      secureStorage.mockSaveStorageError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('Should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('Should return correct value on success', () async {
      final fetchedValue = await sut.fetch(key);

      expect(value, fetchedValue);
    });

    test('Should throw save secure with correct values', () async {
      secureStorage.mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('Should throws if delete item throws', () async {
      secureStorage.mockDeleteSecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
