import 'package:app_curso_manguinho/infra/cache/local_storage_adapter.dart';
import 'package:localstorage/localstorage.dart';

LocalStorageAdapter makeLocalStorageAdapter() => LocalStorageAdapter(
      localStorage: LocalStorage('four_dev'),
    );
