import 'package:app_curso_manguinho/domain/entities/account_entity.dart';
import 'package:faker/faker.dart';

class FakeAccountFactory {
  static Map<String, dynamic> makeApiJson() {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }

  static AccountEntity makeEntity() => AccountEntity(token: faker.guid.guid());
}
