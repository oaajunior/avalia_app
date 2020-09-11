import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/question_answers/question_answers_model.dart';

class EvaluationStudentModel {
  String evaluationId;
  String evaluationTitle;
  String evaluationDiscipline;
  String evaluationCode;
  Timestamp initialDateTime;
  Timestamp finalDateTime;
  Timestamp createdAt;
  String user;
  List<QuestionAnswersModel> listQuestionAnswers;
  double grade;

  EvaluationStudentModel({
    this.evaluationId,
    this.evaluationTitle,
    this.evaluationDiscipline,
    this.evaluationCode,
    this.initialDateTime,
    this.finalDateTime,
    this.createdAt,
    this.user,
    this.listQuestionAnswers,
    this.grade,
  });

  Map<String, dynamic> toMap() => {
        'user': this.user,
        'evaluation_discipline': this.evaluationDiscipline,
        'evaluation_id': this.evaluationId,
        'evaluation_title': this.evaluationTitle,
        'evaluation_code': this.evaluationCode,
        'initial_date': this.initialDateTime,
        'final_date': this.finalDateTime,
        'created_at': FieldValue.serverTimestamp(),
        'grade': this.grade,
        'question_answers': QuestionAnswersModel.getStudentQuestionAnswersToMap(
            this.listQuestionAnswers),
      };

  EvaluationStudentModel.fromMap(
    Map<String, dynamic> studentEvaluation,
  )   : evaluationId = studentEvaluation['evaluation_id'],
        evaluationTitle = studentEvaluation['evaluation_title'],
        evaluationDiscipline = studentEvaluation['evaluation_discipline'],
        evaluationCode = studentEvaluation['evaluation_code'],
        initialDateTime = studentEvaluation['initial_date'],
        finalDateTime = studentEvaluation['final_date'],
        grade = studentEvaluation['grade'],
        createdAt = studentEvaluation['created_at'],
        user = studentEvaluation['user'],
        listQuestionAnswers =
            QuestionAnswersModel.getStudentQuestionAnswersFromMap(
                studentEvaluation['question_answers']);
}
