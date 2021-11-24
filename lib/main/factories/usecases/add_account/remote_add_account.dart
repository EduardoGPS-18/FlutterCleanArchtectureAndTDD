import '../../../../data/usecases/add_account/add_account.dart';
import '../../../../domain/usecases/add_account.dart';
import '../../factories.dart';

AddAccount makeAddAccount() => RemoteAddAccount(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl(''),
    );
