import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:app_curso_manguinho/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  String key;
  dynamic value;
  LocalStorage localStorageSpy;
  LocalStorageAdapter sut;

  void mockDeleteCacheError() => when(localStorageSpy.deleteItem(any)).thenThrow(Exception());

  void mockSaveError() => when(localStorageSpy.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });

  group('move save test to a group', () {
    test('Should call local storage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(localStorageSpy.deleteItem(key)).called(1);
      verify(localStorageSpy.setItem(key, value)).called(1);
    });

    test('Should throws if delete item throws', () async {
      mockDeleteCacheError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throws if delete item throws', () async {
      mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call local storage with correct values', () async {
      await sut.delete(key);

      verify(localStorageSpy.deleteItem(key)).called(1);
    });
  });
}
