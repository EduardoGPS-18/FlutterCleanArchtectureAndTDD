import 'package:mocktail/mocktail.dart';

import 'package:app_curso_manguinho/domain/helpers/helpers.dart';
import 'package:app_curso_manguinho/domain/entities/entities.dart';
import 'package:app_curso_manguinho/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => this.auth(params: any(named: 'params')));
  void mockAuthentication(AccountEntity data) => mockAuthenticationCall().thenAnswer((_) async => data);
  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);
}
