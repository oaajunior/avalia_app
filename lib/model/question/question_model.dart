import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String id;
  bool active;
  String rightAnswer;
  String bncc;
  String description;
  Map<String, String> answerOptions;
  int difficulty;
  int questionType;
  int responseTime;
  String tip;
  Timestamp createdAt;

  QuestionModel({
    this.id,
    this.active,
    this.rightAnswer,
    this.bncc,
    this.description,
    this.answerOptions,
    this.difficulty,
    this.questionType,
    this.responseTime,
    this.tip,
    this.createdAt,
  });

  QuestionModel.fromMap(
    String id,
    Map<String, dynamic> question,
  )   : id = id,
        active = question['active'],
        rightAnswer = question['right_answer'],
        bncc = question['bncc'],
        createdAt = question['created_at'],
        description = question['description'],
        answerOptions = (question['answers'] as Map).cast<String, String>(),
        questionType = question['question_type'],
        difficulty = question['difficulty'],
        responseTime = question['response_time'],
        tip = question['tip'];
}
