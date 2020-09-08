import '../model/evaluation_student/evaluation_student_model.dart';
import '../services/done_evaluation_service.dart';
import '../utils/loading_status.dart';

class DoneEvaluationViewModel {
  DoneEvaluationService service = DoneEvaluationImpl();
  var loadingStatus = LoadingStatus.loading;
  Exception exception;

  Future<List<EvaluationStudentModel>> getStudentEvaluation({
    DateTime initialDate,
    DateTime finalDate,
  }) async {
    List<EvaluationStudentModel> result;
    try {
      loadingStatus = LoadingStatus.loading;
      result = await service.getStudentEvaluation(
          initialDate: initialDate, finalDate: finalDate);
      loadingStatus = LoadingStatus.completed;
      if (result == null || result.length <= 0) {
        loadingStatus = LoadingStatus.empty;
      }
    } catch (error) {
      print(error.toString());
      loadingStatus = LoadingStatus.error;
      exception = error;
    }
    return result;
  }
}
