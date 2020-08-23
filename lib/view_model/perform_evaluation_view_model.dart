import 'package:avalia_app/model/evaluation/evaluation_model.dart';

import '../services/evaluation_service.dart';
import '../utils/loading_status.dart';

class PerformEvaluationViewModel {
  EvaluationService service = EvaluationServiceImpl();
  var loadingStatus = LoadingStatus.loading;
  Exception exception;

  Future<EvaluationModel> getEvaluation(String code) async {
    EvaluationModel result;
    try {
      result = await service.getEvaluation(code);
    } catch (error) {
      print(error.toString());
      exception = error;
    }
    return result;
  }
}
