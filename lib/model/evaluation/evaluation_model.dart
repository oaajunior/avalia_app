import 'package:cloud_firestore/cloud_firestore.dart';

import '../question/question_model.dart';

class EvaluationModel {
  String id;
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
  String user;

  EvaluationModel({
    this.id,
    this.status, //<== Status I indica avaliação Inativa, F - Finalizada e A - Ativa.
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

  EvaluationModel.fromMap(
    String id,
    int totalQuestions,
    String formattedTotalTime,
    List<QuestionModel> questions,
    Map<String, dynamic> evaluation,
  )   : id = id,
        status = evaluation['status'],
        code = evaluation['code'],
        team = evaluation['team'],
        createdAt = evaluation['create_at'],
        title = evaluation['title'],
        discipline = evaluation['discipline'],
        initialDate = evaluation['initial_date'],
        finalDate = evaluation['final_date'],
        question = questions,
        totalQuestions = totalQuestions,
        totalTime = formattedTotalTime,
        stageEducation = evaluation['stage_education'],
        schoolYear = evaluation['school_year'],
        user = evaluation['user'];
}
