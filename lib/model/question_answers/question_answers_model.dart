import 'package:avalia_app/utils/answer_letter.dart';

class QuestionAnswersModel {
  String questionId;
  AnswerLetter rightAnswer;
  String bncc;
  String description;
  Map<AnswerLetter, String> answerOptions;
  AnswerLetter studentAnswer;
  int difficulty;
  int questionType;
  String tip;

  QuestionAnswersModel({
    this.questionId,
    this.rightAnswer,
    this.bncc,
    this.description,
    this.answerOptions,
    this.studentAnswer,
    this.difficulty,
    this.questionType,
    this.tip,
  });

  Map<String, dynamic> toMap() => {
        'question_id': this.questionId,
        'question_bncc': this.bncc,
        'question_type': this.questionType,
        'question_description': this.description,
        'question_difficulty': this.difficulty,
        'answer_options': convertAnswersToString(this.answerOptions),
        'question_right_answer': convertAnswerLetterToString(this.rightAnswer),
        'student_answer': convertAnswerLetterToString(this.studentAnswer),
        'tip': this.tip,
      };

  QuestionAnswersModel.fromMap(Map<String, dynamic> answerOptions)
      : questionId = answerOptions['question_id'],
        bncc = answerOptions['question_bncc'],
        questionType = answerOptions['question_type'],
        description = answerOptions['question_description'],
        difficulty = answerOptions['question_difficulty'],
        answerOptions = getAnswersFromMap(answerOptions['answer_options']),
        rightAnswer = getAnswerLetter(answerOptions['question_right_answer']),
        studentAnswer = getAnswerLetter(answerOptions['student_answer']),
        tip = answerOptions['tip'];

  static List<Map<String, dynamic>> getStudentQuestionAnswersToMap(
      List<QuestionAnswersModel> listQuestionAnswer) {
    List<Map<String, dynamic>> firestoreMap = [];

    listQuestionAnswer.forEach((questionAnswer) {
      firestoreMap.add(questionAnswer.toMap());
    });
    return firestoreMap;
  }

  static List<QuestionAnswersModel> getStudentQuestionAnswersFromMap(
      List<dynamic> firestoreMap) {
    List<QuestionAnswersModel> listQuestionAnswer = [];

    firestoreMap.forEach((questionAnswer) {
      listQuestionAnswer.add(QuestionAnswersModel.fromMap(questionAnswer));
    });
    return listQuestionAnswer;
  }

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

  static Map<String, dynamic> convertAnswersToString(
      Map<AnswerLetter, String> optionAnswers) {
    Map<String, dynamic> map = Map<String, dynamic>();
    optionAnswers.forEach((key, value) {
      String letter = convertAnswerLetterToString(key);
      map.putIfAbsent(letter, () => value);
    });
    return map;
  }

  static String convertAnswerLetterToString(AnswerLetter answerLetter) {
    final userAnswer = answerLetter.toString().split('.').last;
    final userFinalAnswer = userAnswer == 'none' ? 'E' : userAnswer;
    return userFinalAnswer;
  }
}
