class QuestionAnswersModel {
  String questionId;
  String rightAnswer;
  String bncc;
  String description;
  Map<String, String> answerOptions;
  String studentAnswer;
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
        'answer_options': this.answerOptions,
        'question_right_answer': this.rightAnswer,
        'student_answer': this.studentAnswer,
        'tip': this.tip,
      };
}
