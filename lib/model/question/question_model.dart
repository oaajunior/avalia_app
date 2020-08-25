import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  bool active;
  int rightAnswer;
  String bncc;
  String description;
  List<String> answers;
  int difficulty;
  int questionType;
  int responseTime;
  String tip;
  Timestamp createdAt;

  QuestionModel({
    this.active,
    this.rightAnswer,
    this.bncc,
    this.description,
    this.answers,
    this.difficulty,
    this.questionType,
    this.responseTime,
    this.tip,
    this.createdAt,
  });
}
