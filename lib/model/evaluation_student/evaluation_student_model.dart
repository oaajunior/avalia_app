import 'package:avalia_app/model/question_answers/question_answers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluationStudentModel {
  String evaluationId;
  String evaluationTitle;
  String evaluationDiscipline;
  String evaluationCode;
  Timestamp initialDateTime;
  Timestamp finalDateTime;
  String user;
  List<QuestionAnswersModel> listQuestionAnswer;
  double grade;

  EvaluationStudentModel({
    this.evaluationId,
    this.evaluationTitle,
    this.evaluationDiscipline,
    this.evaluationCode,
    this.initialDateTime,
    this.finalDateTime,
    this.user,
    this.listQuestionAnswer,
    this.grade,
  });

  Map<String, dynamic> toMap() => {
        'user': this.user,
        'discipline': this.evaluationDiscipline,
        'evaluation_id': this.evaluationId,
        'evaluation_title': this.evaluationTitle,
        'evaluation_code': this.evaluationCode,
        'initial_date': this.initialDateTime,
        'final_date': this.finalDateTime,
        'grade': this.grade,
        'question_answers': getStudentQuestionAnswers(this.listQuestionAnswer),
      };

  List<Map<String, dynamic>> getStudentQuestionAnswers(
      List<QuestionAnswersModel> listQuestionAnswer) {
    List<Map<String, dynamic>> firestoreMap = [];

    listQuestionAnswer.forEach((questionAnswer) {
      firestoreMap.add(questionAnswer.toMap());
    });
    return firestoreMap;
  }
}
