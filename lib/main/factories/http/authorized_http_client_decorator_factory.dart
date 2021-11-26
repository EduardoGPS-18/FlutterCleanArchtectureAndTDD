import '../../../data/http/http.dart';

import '../factories.dart';
import '../../decorators/decorators.dart';

HttpClient makeAuthorizedHttpClientDecoratorAdapter() {
  return AuthorizedHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
  );
}
