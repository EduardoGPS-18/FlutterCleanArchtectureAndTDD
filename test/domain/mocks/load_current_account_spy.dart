import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCurrentAccountCall() => when(() => this.load());
  void mockLoadCurrentAccount(AccountEntity account) => mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  void mockLoadCurrentAccountError() => mockLoadCurrentAccountCall().thenThrow(Exception());
}
