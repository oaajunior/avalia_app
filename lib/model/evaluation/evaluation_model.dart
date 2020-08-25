import 'package:cloud_firestore/cloud_firestore.dart';

import '../question/question_model.dart';

class EvaluationModel {
  String status;
  String code;
  String title;
  String discipline;
  Timestamp initialDate;
  Timestamp finalDate;
  String team;
  List<QuestionModel> question;
  String stageEducation;
  int totalQuestions;
  String totalTime;
  Timestamp createdAt;
  int schoolYear;
  DocumentReference user;

  EvaluationModel({
    this.status,
    this.code,
    this.title,
    this.discipline,
    this.initialDate,
    this.finalDate,
    this.team,
    this.question,
    this.stageEducation,
    this.totalQuestions,
    this.totalTime,
    this.createdAt,
    this.schoolYear,
    this.user,
  });
}
