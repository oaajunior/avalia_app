import '../model/evaluation/evaluation_model.dart';
import '../model/evaluation_student/evaluation_student_model.dart';
import '../services/perform_evaluation_service.dart';
import '../utils/loading_status.dart';

class PerformEvaluationViewModel {
  PerformEvaluationService service = EvaluationServiceImpl();
  var loadingStatus = LoadingStatus.loading;
  Exception exception;

  Future<EvaluationModel> getEvaluation(String code) async {
    EvaluationModel result;
    try {
      loadingStatus = LoadingStatus.loading;
      result = await service.getEvaluation(code);
      loadingStatus = LoadingStatus.completed;
      if (result == null) {
        loadingStatus = LoadingStatus.empty;
      }
    } catch (error) {
      print(error.toString());
      loadingStatus = LoadingStatus.error;
      exception = error;
    }
    return result;
  }

  Future<void> saveStudentEvaluation(
      EvaluationStudentModel evaluationStudent) async {
    try {
      loadingStatus = LoadingStatus.loading;
      await service.saveStudentEvaluation(evaluationStudent);
      loadingStatus = LoadingStatus.completed;
    } catch (error) {
      loadingStatus = LoadingStatus.error;
      exception = error;
    }
  }
}
