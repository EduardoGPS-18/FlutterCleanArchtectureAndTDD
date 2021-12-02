import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageSpy extends Mock implements LocalStorage {
  LocalStorageSpy() {
    mockSave();
    mockDelete();
  }

  When mockDeleteCall() => when(() => deleteItem(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) async => _);
  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  When mockFetchCall() => when(() => getItem(any()));
  void mockFetch<T>(T data) => mockFetchCall().thenAnswer((_) async => data);
  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  When mockSaveCall() => when(() => setItem(any(), any()));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}
