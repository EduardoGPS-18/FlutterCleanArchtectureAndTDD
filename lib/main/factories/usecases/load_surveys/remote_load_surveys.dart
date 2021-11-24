import '../../../../domain/usecases/load_surveys.dart';

import '../../../../data/usecases/load_surveys/load_surveys.dart';

import '../../factories.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeHttpAdapter(),
      url: makeApiUrl('/surveys'),
    );
