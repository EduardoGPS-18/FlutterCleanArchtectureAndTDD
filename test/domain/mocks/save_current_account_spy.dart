import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/usecases/usecases.dart';
import 'package:app_curso_manguinho/domain/helpers/helpers.dart';

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {
  SaveCurrentAccountSpy() {
    mockSaveCurrentAccount();
  }

  When mockSaveCurrentAccountCall() => when(() => this.save(any()));
  void mockSaveCurrentAccount() => mockSaveCurrentAccountCall().thenAnswer((_) async => _);
  void mockSaveCurrentAccountError(DomainError error) => mockSaveCurrentAccountCall().thenThrow(error);
}
