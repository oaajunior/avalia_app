import 'package:auto_size_text/auto_size_text.dart';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    extends State<EvaluationQuestionnaireView> with TickerProviderStateMixin {
  final _groupOfTextsRadios = AutoSizeGroup();
  FocusNode caputureKey = FocusNode();

  @override
  void dispose() {
    caputureKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final _question = Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: widget.color,
                ),
            child: AutoSizeText(
              '${widget.indexQuestion + 1}. ',
              wrapWords: false,
              group: _groupOfTextsRadios,
              maxLines: 1,
            ),
          ),
          Container(
            width: deviceSize.width * 0.75,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: widget.color,
                  ),
              child: AutoSizeText(
                widget.isPerformEvaluation
                    ? widget.question.description
                    : widget.studentEvaluation
                        .listQuestionAnswers[widget.indexQuestion].description,
                textAlign: TextAlign.left,
                wrapWords: false,
                group: _groupOfTextsRadios,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _buildOptions(AnswerLetter answerLetter, String letter,
        String optionAnswer, isSetToFalse) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: deviceSize.height * 0.08),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Transform.scale(
              scale: 0.9,
              child: CircularCheckBox(
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    GestureDetector(
                      onTap: widget.isPerformEvaluation
                          ? () {
                              final resultLetter =
                                  widget.getAnswerLetter(answerLetter);
                              widget.turnAllAnswerLetterToFalse();
                              widget.setAnswerLetter(
                                answerLetter,
                                resultLetter == true ? false : true,
                              );
                            }
                          : () => {},
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: widget.color,
                            ),
                        child: AutoSizeText(
                          letter,
                          wrapWords: false,
                          textAlign: TextAlign.left,
                          group: _groupOfTextsRadios,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.isPerformEvaluation
                          ? () {
                              final resultLetter =
                                  widget.getAnswerLetter(answerLetter);
                              widget.turnAllAnswerLetterToFalse();
                              widget.setAnswerLetter(
                                answerLetter,
                                resultLetter == true ? false : true,
                              );
                            }
                          : () => {},
                      child: FittedBox(
                        child: Container(
                          width: deviceSize.width * 0.67,
                          child: DefaultTextStyle(
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: widget.color,
                                    ),
                            child: AutoSizeText(
                              optionAnswer,
                              minFontSize: 16,
                              stepGranularity: 1,
                              wrapWords: false,
                              textAlign: TextAlign.left,
                              group: _groupOfTextsRadios,
                              maxLines: 3,
                            ),
                          ),
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

    // void setToFalseRadioButtons() {
    //   for (var i = 0; i < 4; i++) {
    //     _buildOptions(
    //       AnswerLetter.A,
    //       '',
    //       '',
    //       true,
    //     );
    //   }
    // }

    final _questionOptions = FittedBox(
      child: Container(
        margin: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
        ),
        height: deviceSize.height * 0.77,
        width: deviceSize.width * 0.9,
        child: ListView(
          children: [
            _question,
            _buildOptions(
              AnswerLetter.A,
              'A - ',
              widget.isPerformEvaluation
                  ? widget.question.answerOptions[AnswerLetter.A]
                  : widget
                      .studentEvaluation
                      .listQuestionAnswers[widget.indexQuestion]
                      .answerOptions[AnswerLetter.A],
              false,
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
              false,
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
              false,
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
              false,
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: deviceSize.width * 0.9,
      height: widget.isPerformEvaluation
          ? deviceSize.height * 0.72
          : deviceSize.height * 0.72,
      child: ListView(
        children: [
          RawKeyboardListener(
            focusNode: caputureKey,
            autofocus: true,
            onKey: (RawKeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.keyP) {
                Navigator.of(context).pop();
              }
            },
            child: _questionOptions,
          ),
        ],
      ),
    );
  }
}
