import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../question/question_model.dart';

class EvaluationModel {
  String status;
  String code;
  String title;
  String discipline;
  Timestamp initialDate;
  Timestamp finalDate;
  String grade;
  List<QuestionModel> question;
  String stageEducation;
  int totalQuestions;
  TimeOfDay totalTime;
  Timestamp createdAt;
  DocumentReference user;

  EvaluationModel({
    this.status,
    this.code,
    this.title,
    this.discipline,
    this.initialDate,
    this.finalDate,
    this.grade,
    this.question,
    this.stageEducation,
    this.totalQuestions,
    this.totalTime,
    this.createdAt,
    this.user,
  });
}
