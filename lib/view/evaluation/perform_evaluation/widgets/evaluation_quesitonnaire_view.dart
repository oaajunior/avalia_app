import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';

import '../../../../res/custom_icon.dart';
import '../../../../view/ranking/ranking_view.dart';
import '../../../../res/colors.dart';
import '../../../../utils/student_answer.dart';
import '../../../../model/evaluation_student/evaluation_student_model.dart';
import '../../../../model/question/question_model.dart';
import '../../../../utils/answer_letter.dart';

// ignore: must_be_immutable
class EvaluationQuestionnaireView extends StatefulWidget {
  int indexQuestion;
  QuestionModel question;
  Function getAnswerLetter;
  Function setAnswerLetter;
  EvaluationStudentModel studentEvaluation;
  bool isPerformEvaluation = false;
  Color color;
  bool checkValue = false;
  Function turnAllAnswerLetterToFalse;

  EvaluationQuestionnaireView.performEvaluation(
      this.indexQuestion,
      this.question,
      this.getAnswerLetter,
      this.setAnswerLetter,
      this.isPerformEvaluation,
      this.color,
      this.turnAllAnswerLetterToFalse);

  EvaluationQuestionnaireView.doneEvaluation(
    this.studentEvaluation,
    this.indexQuestion,
    this.getAnswerLetter,
    this.color,
  );

  @override
  _EvaluationQuestionnaireViewState createState() =>
      _EvaluationQuestionnaireViewState();
}

class _EvaluationQuestionnaireViewState
    extends State<EvaluationQuestionnaireView> {
  final _groupOfTextsRadios = AutoSizeGroup();

  void _goToPage() {
    Navigator.of(context).pushNamed(
      RankingView.routeName,
      arguments: widget.studentEvaluation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final _question = Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 24.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: widget.color,
                ),
            child: AutoSizeText(
              '${widget.indexQuestion + 1}. ',
              wrapWords: false,
              maxLines: 2,
            ),
          ),
          Container(
            width: deviceSize.width * 0.73,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: widget.color,
                  ),
              child: AutoSizeText(
                widget.isPerformEvaluation
                    ? widget.question.description
                    : widget.studentEvaluation
                        .listQuestionAnswers[widget.indexQuestion].description,
                textAlign: TextAlign.left,
                wrapWords: false,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _buildOptions(
        AnswerLetter answerLetter, String letter, String optionAnswer) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: deviceSize.height * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            CircularCheckBox(
              activeColor: widget.isPerformEvaluation
                  ? widget.color
                  : widget.getAnswerLetter(answerLetter) ==
                          StudentAnswer.STUDENT_WRONG
                      ? redColor
                      : widget.color,
              checkColor: whiteColor,
              disabledColor: greenSoftColor,
              inactiveColor: widget.color,
              tristate: widget.isPerformEvaluation ? false : true,
              value: widget.isPerformEvaluation
                  ? widget.getAnswerLetter(answerLetter)
                  : widget.getAnswerLetter(answerLetter) == StudentAnswer.NONE
                      ? false
                      : widget.getAnswerLetter(answerLetter) ==
                              StudentAnswer.STUDENT_WRONG
                          ? null
                          : true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: widget.isPerformEvaluation
                  ? (bool value) {
                      widget.turnAllAnswerLetterToFalse();
                      widget.setAnswerLetter(answerLetter, value);
                    }
                  : widget.getAnswerLetter(answerLetter) ==
                          StudentAnswer.STUDENT_BLANK
                      ? null
                      : widget.getAnswerLetter(answerLetter) ==
                              StudentAnswer.NONE
                          ? (bool value) => false
                          : (bool value) => true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: widget.color,
                          ),
                      child: Text(letter),
                    ),
                    Container(
                      width: deviceSize.width * 0.67,
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: widget.color,
                            ),
                        child: AutoSizeText(
                          optionAnswer,
                          wrapWords: false,
                          textAlign: TextAlign.left,
                          group: _groupOfTextsRadios,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _answersOptions = Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: 8.0,
      ),
      //height: deviceSize.height * 0.45,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildOptions(
            AnswerLetter.A,
            'A - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions[AnswerLetter.A]
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions[AnswerLetter.A],
          ),
          _buildOptions(
            AnswerLetter.B,
            'B - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions[AnswerLetter.B]
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions[AnswerLetter.B],
          ),
          _buildOptions(
            AnswerLetter.C,
            'C - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions[AnswerLetter.C]
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions[AnswerLetter.C],
          ),
          _buildOptions(
            AnswerLetter.D,
            'D - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions[AnswerLetter.D]
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions[AnswerLetter.D],
          ),
        ],
      ),
    );

    final _ranking = Container(
      margin: const EdgeInsets.only(top: 8.0),
      child: RaisedButton.icon(
        label: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: purpleDeepColor,
                fontWeight: FontWeight.w600,
              ),
          child: Text('Ranking'),
        ),
        onPressed: () => _goToPage(),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        icon: Icon(
          CustomIcon.icon_ranking,
          size: 40,
          color: purpleDeepColor,
        ),
        color: whiteColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: purpleDeepColor, width: 1.3),
        ),
      ),
    );

    final _header = Container(
      width: deviceSize.width * 0.8,
      height: deviceSize.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ranking,
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: deviceSize.width * 0.9,
      height: widget.isPerformEvaluation
          ? deviceSize.height * 0.66
          : deviceSize.height * 0.75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isPerformEvaluation) _header,
          _question,
          _answersOptions,
        ],
      ),
    );
  }
}
