import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {
  late String key;
  late String result;
  late dynamic value;
  late LocalStorageSpy localStorageSpy;
  late LocalStorageAdapter sut;

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorageSpy = LocalStorageSpy();

    result = faker.randomGenerator.string(50);
    localStorageSpy.mockFetch(result);

    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });

  group('save', () {
    test('Should call local storage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorageSpy.deleteItem(key)).called(1);
      verify(() => localStorageSpy.setItem(key, value)).called(1);
    });

    test('Should throws if delete item throws', () async {
      localStorageSpy.mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throws if delete item throws', () async {
      localStorageSpy.mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call local storage with correct values', () async {
      await sut.delete(key);

      verify(() => localStorageSpy.deleteItem(key)).called(1);
    });

    test('Should throws if delete item throws', () async {
      localStorageSpy.mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('Should call local storage with correct values', () async {
      await sut.fetch(key);

      verify(() => localStorageSpy.getItem(key)).called(1);
    });

    test('Should rethrows if fetch throw exceptions', () async {
      localStorageSpy.mockFetchError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should returns storage value', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });
  });
}
