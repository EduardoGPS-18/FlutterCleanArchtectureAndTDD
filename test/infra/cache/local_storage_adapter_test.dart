import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;
  LocalStorageAdapter({
    @required this.localStorage,
  });
  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  String key;
  dynamic value;
  LocalStorage localStorageSpy;
  LocalStorageAdapter sut;

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorageSpy = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorageSpy);
  });

  test('Should call local storage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorageSpy.setItem(key, value)).called(1);
  });
}
