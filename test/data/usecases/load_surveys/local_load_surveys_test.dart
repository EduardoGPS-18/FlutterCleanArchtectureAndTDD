import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({
    @required this.fetchCacheStorage,
  });

  Future<void> load() async {
    await fetchCacheStorage.fetch(key: 'surveys');
  }
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

abstract class FetchCacheStorage {
  Future<void> fetch({@required String key});
}

void main() {
  FetchCacheStorage fetchCacheStorage;
  LocalLoadSurveys sut;

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
  });

  test('Should call fetch cache storage with correct key', () async {
    await sut.load();

    verify(fetchCacheStorage.fetch(key: 'surveys')).called(1);
  });
}
