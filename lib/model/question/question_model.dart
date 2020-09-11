import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/answer_letter.dart';

class QuestionModel {
  String id;
  bool active;
  AnswerLetter rightAnswer;
  String bncc;
  String description;
  Map<AnswerLetter, String> answerOptions;
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
        rightAnswer = getAnswerLetter(question['right_answer']),
        bncc = question['bncc'],
        createdAt = question['created_at'],
        description = question['description'],
        answerOptions = getAnswersFromMap(question['answers']),
        questionType = question['question_type'],
        difficulty = question['difficulty'],
        responseTime = question['response_time'],
        tip = question['tip'];

  static AnswerLetter getAnswerLetter(String letterAnswer) {
    switch (letterAnswer) {
      case 'A':
        return AnswerLetter.A;
        break;
      case 'B':
        return AnswerLetter.B;
        break;
      case 'C':
        return AnswerLetter.C;
        break;
      case 'D':
        return AnswerLetter.D;
        break;
      default:
        return AnswerLetter.E;
    }
  }

  static Map<AnswerLetter, String> getAnswersFromMap(
      Map<String, dynamic> optionAnswers) {
    Map<AnswerLetter, String> map = Map<AnswerLetter, String>();
    optionAnswers.forEach((key, value) {
      AnswerLetter letter = getAnswerLetter(key);
      map.putIfAbsent(letter, () => value);
    });
    return map;
  }
}
