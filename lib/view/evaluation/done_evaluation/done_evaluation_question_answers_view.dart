import 'package:flutter/material.dart';

import '../../../utils/answer_letter.dart';
import '../../../utils/student_answer.dart';
import '../../../view/layout/layout_page.dart';
import '../../../view/evaluation/perform_evaluation/widgets/evaluation_quesitonnaire_view.dart';
import '../../../model/evaluation_student/evaluation_student_model.dart';
import '../../../res/colors.dart';
import '../../../view/layout/layout_buttons.dart';

class DoneEvaluationQuestionAnswersView extends StatefulWidget {
  static const routeName = 'done_evaluation_question_answers';
  final EvaluationStudentModel studentEvaluation;
  DoneEvaluationQuestionAnswersView(this.studentEvaluation);

  @override
  _DoneEvaluationQuestionAnswersViewState createState() =>
      _DoneEvaluationQuestionAnswersViewState();
}

class _DoneEvaluationQuestionAnswersViewState
    extends State<DoneEvaluationQuestionAnswersView> {
  Map<AnswerLetter, StudentAnswer> _answerLetters;
  int _indexQuestion = 0;

  void _nextQuestion() {
    if (_indexQuestion <
        widget.studentEvaluation.listQuestionAnswers.length - 1) {
      setState(() {
        _indexQuestion++;
      });
      _mountOptionAnswers();
    }
  }

  void _beforeQuestion() {
    if (_indexQuestion > 0) {
      setState(() {
        _indexQuestion--;
      });
      _mountOptionAnswers();
    }
  }

  void _mountOptionAnswers() {
    _answerLetters = Map<AnswerLetter, StudentAnswer>();

    final listQuestionAnswers =
        widget.studentEvaluation.listQuestionAnswers[_indexQuestion];

    listQuestionAnswers.answerOptions.forEach((keyLetter, value) {
      if (keyLetter == listQuestionAnswers.rightAnswer &&
          keyLetter == listQuestionAnswers.studentAnswer) {
        _answerLetters.putIfAbsent(
            keyLetter, () => StudentAnswer.STUDENT_RIGHT);
      } else if (keyLetter == listQuestionAnswers.studentAnswer &&
          keyLetter != AnswerLetter.E) {
        _answerLetters.putIfAbsent(
            keyLetter, () => StudentAnswer.STUDENT_WRONG);
      } else if (keyLetter == listQuestionAnswers.rightAnswer) {
        _answerLetters.putIfAbsent(
            keyLetter, () => StudentAnswer.STUDENT_BLANK);
      } else {
        _answerLetters.putIfAbsent(keyLetter, () => StudentAnswer.NONE);
      }
    });
  }

  StudentAnswer getAnswerLetter(AnswerLetter letter) {
    return _answerLetters[letter];
  }

  @override
  void initState() {
    _mountOptionAnswers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _questionnaire = EvaluationQuestionnaireView.doneEvaluation(
      widget.studentEvaluation,
      _indexQuestion,
      getAnswerLetter,
      greenDeepColor,
    );

    Widget _buildOneButton(String name, Function buttonFunction) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LayoutButtons.customRaisedButtons(
              textRaisedButtonOne: name,
              color: greenDeepColor,
              context: context,
              onPressedButtonOne: buttonFunction,
            ),
          ],
        ),
      );
    }

    Widget _buildTwoButtons(String name, Function buttonFunction) {
      return Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Container(
          height: 60,
          width: _deviceSize.width * 0.4,
          child: RaisedButton(
            color: Theme.of(context).backgroundColor,
            onPressed: buttonFunction,
            child: Text(
              name,
              style: TextStyle(
                color: greenDeepColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    final _buttonNextAndBackPage = Container(
      width: _deviceSize.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTwoButtons(
            'Anterior',
            _beforeQuestion,
          ),
          _buildTwoButtons(
            'Próxima',
            _nextQuestion,
          ),
        ],
      ),
    );

    final _content = SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: _deviceSize.height * 0.75,
          maxHeight: _deviceSize.height * 0.87,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _questionnaire,
            if (_indexQuestion == 0)
              _buildOneButton(
                'Próxima',
                _nextQuestion,
              ),
            if (_indexQuestion > 0 &&
                _indexQuestion <
                    widget.studentEvaluation.listQuestionAnswers.length - 1)
              _buttonNextAndBackPage,
            if (_indexQuestion ==
                widget.studentEvaluation.listQuestionAnswers.length - 1)
              _buildOneButton(
                'Anterior',
                _beforeQuestion,
              ),
          ],
        ),
      ),
    );

    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: widget.studentEvaluation.evaluationDiscipline,
      color: greenDeepColor,
      context: context,
      content: _content,
    );
  }
}