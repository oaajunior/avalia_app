import 'package:auto_size_text/auto_size_text.dart';
import 'package:avalia_app/res/colors.dart';
import 'package:avalia_app/res/custom_icon_button.dart';
import 'package:flutter/material.dart';

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

  EvaluationQuestionnaireView.performEvaluation(
    this.indexQuestion,
    this.question,
    this.getAnswerLetter,
    this.setAnswerLetter,
    this.isPerformEvaluation,
    this.color,
  );

  EvaluationQuestionnaireView.doneEvaluation(
    this.studentEvaluation,
    this.indexQuestion,
    this.color,
  );

  @override
  _EvaluationQuestionnaireViewState createState() =>
      _EvaluationQuestionnaireViewState();
}

class _EvaluationQuestionnaireViewState
    extends State<EvaluationQuestionnaireView> {
  final _groupOfTextsRadios = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final _question = Padding(
      padding: const EdgeInsets.only(top: 0.0, left: 24.0, right: 24.0),
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
            width: deviceSize.width * 0.7,
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: widget.color,
                toggleableActiveColor: widget.color,
                disabledColor: widget.color,
              ),
              child: Radio(
                activeColor: widget.color,
                value: answerLetter,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                toggleable: true,
                groupValue: widget.isPerformEvaluation
                    ? widget.getAnswerLetter()
                    : answerLetter ==
                            widget
                                .studentEvaluation
                                .listQuestionAnswers[widget.indexQuestion]
                                .rightAnswer
                        ? answerLetter
                        : answerLetter ==
                                widget
                                    .studentEvaluation
                                    .listQuestionAnswers[widget.indexQuestion]
                                    .studentAnswer
                            ? answerLetter
                            : null,
                onChanged: widget.isPerformEvaluation
                    ? (dynamic value) {
                        widget.setAnswerLetter(value);
                      }
                    : null,
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
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
          ],
        ),
      );
    }

    final _answersOptions = Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 8.0,
      ),
      height: deviceSize.height * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptions(
            AnswerLetter.A,
            'A - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions['A']
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions['A'],
          ),
          _buildOptions(
            AnswerLetter.B,
            'B - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions['B']
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions['B'],
          ),
          _buildOptions(
            AnswerLetter.C,
            'C - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions['C']
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions['C'],
          ),
          _buildOptions(
            AnswerLetter.D,
            'D - ',
            widget.isPerformEvaluation
                ? widget.question.answerOptions['D']
                : widget
                    .studentEvaluation
                    .listQuestionAnswers[widget.indexQuestion]
                    .answerOptions['D'],
          ),
        ],
      ),
    );

    final _ranking = Container(
      child: IconButton(
        onPressed: () {},
        color: purpleDeepColor,
        iconSize: 40,
        icon: Icon(
          CustomIconButton.button_ranking,
        ),
      ),
    );

    final _header = Container(
      width: deviceSize.width * 0.6,
      height: deviceSize.height * 0.09,
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
