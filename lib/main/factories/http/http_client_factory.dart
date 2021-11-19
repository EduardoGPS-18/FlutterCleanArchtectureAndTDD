import 'package:app_curso_manguinho/data/http/http.dart';
import 'package:app_curso_manguinho/infra/http/http.dart';
import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  return HttpAdapter(Client());
}
