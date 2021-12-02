import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

class AddAccountSpy extends Mock implements AddAccount {
  When mockAddAccountCall() => when(() => this.add(params: any(named: 'params')));
  void mockAddAccount(AccountEntity entity) => mockAddAccountCall().thenAnswer((_) async => entity);
  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);
}
