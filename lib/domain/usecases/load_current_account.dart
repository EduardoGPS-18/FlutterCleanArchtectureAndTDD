import 'package:app_curso_manguinho/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity> load();
}
