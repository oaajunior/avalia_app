import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  bool active;
  int answer;
  String bncc;
  String description;
  int difficulty;
  int questionType;
  int responseTime;
  String tip;
  Timestamp createdAt;

  QuestionModel({
    this.active,
    this.answer,
    this.bncc,
    this.description,
    this.difficulty,
    this.questionType,
    this.responseTime,
    this.tip,
    this.createdAt,
  });
}
