import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../layout/layout_page.dart';
import '../../.././model/evaluation/evaluation_model.dart';
import '../../../res/colors.dart';
import '../../layout/layout_buttons.dart';
import '../../../utils/answer_letter.dart';

class PerformEvaluationQuestionsView extends StatefulWidget {
  static const routeName = '/perform_evaluation_questions';
  final EvaluationModel evaluation;
  PerformEvaluationQuestionsView(this.evaluation);

  @override
  _PerformEvaluationQuestionsViewState createState() =>
      _PerformEvaluationQuestionsViewState();
}

class _PerformEvaluationQuestionsViewState
    extends State<PerformEvaluationQuestionsView> {
  AnswerLetter _answerLetter = AnswerLetter.none;
  final _groupOfTextsRadios = AutoSizeGroup();

  int _indexQuestion = 0;
  void nextQuestion() {
    if (_indexQuestion < widget.evaluation.question.length - 1) {
      setState(() {
        _indexQuestion++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var question = widget.evaluation.question[_indexQuestion];
    double questionsNumberOfCharacters =
        (widget.evaluation.question[_indexQuestion].description.length)
            .toDouble();
    final numberFormat = NumberFormat('00');
    final numberOfQuestions = widget.evaluation.question.length;
    final progressOfQuestions =
        ((_indexQuestion + 1) / numberOfQuestions).toPrecision(1);

    final _title = Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Questão',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            '${numberFormat.format(_indexQuestion + 1)}/${numberFormat.format(widget.evaluation.question.length)}',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    final _progressIndicator = Container(
      width: deviceSize.width * 0.4,
      child: Center(
        child: LinearPercentIndicator(
          lineHeight: 8.0,
          percent: progressOfQuestions,
          backgroundColor: whiteColor,
          progressColor: greenDeepColor,
          linearStrokeCap: LinearStrokeCap.roundAll,
          animation: false,
        ),
      ),
    );

    final _answersAC = Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: (questionsNumberOfCharacters <= 90.0) ? 80.0 : 110.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: yellowDeepColor,
              disabledColor: yellowDeepColor,
              toggleableActiveColor: yellowDeepColor,
            ),
            child: Radio(
              value: AnswerLetter.A,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              toggleable: true,
              groupValue: _answerLetter,
              onChanged: (AnswerLetter value) {
                setState(() {
                  _answerLetter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: yellowDeepColor,
                      ),
                  child: Text('A - '),
                ),
                Container(
                  width: deviceSize.width * 0.25,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: yellowDeepColor,
                        ),
                    child: AutoSizeText(
                      question.answers[0],
                      textAlign: TextAlign.left,
                      group: _groupOfTextsRadios,
                      maxLines: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: yellowDeepColor,
              disabledColor: yellowDeepColor,
              toggleableActiveColor: yellowDeepColor,
            ),
            child: Radio(
              value: AnswerLetter.C,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              toggleable: true,
              groupValue: _answerLetter,
              onChanged: (AnswerLetter value) {
                setState(() {
                  _answerLetter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: yellowDeepColor,
                      ),
                  child: Text('C - '),
                ),
                Container(
                  width: deviceSize.width * 0.25,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: yellowDeepColor,
                        ),
                    child: AutoSizeText(
                      question.answers[2],
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                      group: _groupOfTextsRadios,
                      maxLines: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final _answersBD = Container(
      margin: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        top: 68,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: yellowDeepColor,
              disabledColor: yellowDeepColor,
              toggleableActiveColor: yellowDeepColor,
            ),
            child: Radio(
              value: AnswerLetter.B,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              toggleable: true,
              groupValue: _answerLetter,
              onChanged: (AnswerLetter value) {
                setState(() {
                  _answerLetter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: yellowDeepColor,
                      ),
                  child: Text('B - '),
                ),
                Container(
                  width: deviceSize.width * 0.25,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: yellowDeepColor,
                        ),
                    child: AutoSizeText(
                      question.answers[1],
                      textAlign: TextAlign.left,
                      group: _groupOfTextsRadios,
                      maxLines: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: yellowDeepColor,
              disabledColor: yellowDeepColor,
              toggleableActiveColor: yellowDeepColor,
            ),
            child: Radio(
              value: AnswerLetter.D,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              toggleable: true,
              groupValue: _answerLetter,
              onChanged: (AnswerLetter value) {
                setState(() {
                  _answerLetter = value;
                });
              },
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: yellowDeepColor,
                      ),
                  child: Text('D - '),
                ),
                Container(
                  width: deviceSize.width * 0.25,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: yellowDeepColor,
                        ),
                    child: AutoSizeText(
                      question.answers[3],
                      textAlign: TextAlign.left,
                      group: _groupOfTextsRadios,
                      maxLines: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
            textRaisedButtonOne: 'Próxima',
            color: yellowDeepColor,
            context: context,
            onPressedButtonOne: nextQuestion,
          ),
        ],
      ),
    );

    final _question = Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: yellowDeepColor,
                ),
            child: Text(
              '${_indexQuestion + 1}. ',
            ),
          ),
          Container(
            width: deviceSize.width * 0.7,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: yellowDeepColor,
                  ),
              child: AutoSizeText(
                question.description,
                textAlign: TextAlign.left,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );

    final _questionnaire = Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.56,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _question,
          _answersAC,
          _answersBD,
        ],
      ),
    );

    final _content = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: deviceSize.height * 0.79,
          maxHeight: deviceSize.height * 0.79,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _title,
            _progressIndicator,
            _questionnaire,
            _button,
          ],
        ));
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'avalia',
      context: context,
      color: yellowDeepColor,
      content: _content,
    );
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
