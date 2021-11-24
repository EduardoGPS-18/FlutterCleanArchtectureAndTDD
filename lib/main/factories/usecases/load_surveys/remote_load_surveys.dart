import 'package:app_curso_manguinho/main/factories/factories.dart';

import '../../../../domain/usecases/load_surveys.dart';

import '../../../../data/usecases/load_surveys/load_surveys.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('/surveys'),
    );
