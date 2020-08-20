import 'package:avalia_app/model/evaluation/evaluation_model.dart';

import '../services/evaluation_service.dart';
import '../utils/loading_status.dart';

class RealizarAvaliacaoViewModel {
  EvaluationService service = EvaluationServiceImpl();
  var loadingStatus = LoadingStatus.loading;
  Exception userException;

  Future<EvaluationModel> getEvaluation(String code) async {
    try {
      await service.getEvaluation(code);
    } catch (error) {
      print(error);
    }
  }
}
