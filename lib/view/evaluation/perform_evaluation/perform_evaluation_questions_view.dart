import 'dart:math';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../res/custom_icon.dart';
import '../../../utils/loading_status.dart';
import '../../../model/question_answers/question_answers_model.dart';
import '../../../model/evaluation_student/evaluation_student_model.dart';
import '../../../view_model/user_acess_view_model.dart';
import '../../layout/layout_page.dart';
import '../../.././model/evaluation/evaluation_model.dart';
import '../../../res/colors.dart';
import '../../layout/layout_buttons.dart';
import '../../../utils/answer_letter.dart';
import '../../../view_model/perform_evaluation_view_model.dart';
import '../../../view/layout/layout_alert.dart';

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
  final _groupOfTextsRadios = AutoSizeGroup();
  final _viewModelUser = UserAccessViewModel();
  final _viewModelEvaluation = PerformEvaluationViewModel();
  AnswerLetter _answerLetter = AnswerLetter.none;
  EvaluationStudentModel _evaluationStudent;
  List<QuestionAnswersModel> _listQuestionAnswer = List<QuestionAnswersModel>();
  QuestionAnswersModel _questionAnswers;
  Timer _timerToCancel;
  double _timeToResponse = 0.0;
  int _indexQuestion = 0;
  bool _lastQuestion = false;
  bool _isLoading = false;
  int _timeToAnswer = 0;

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  bool getIsLoading() {
    return _isLoading;
  }

  void _nextQuestion() {
    if (_indexQuestion < widget.evaluation.question.length - 1) {
      _performStudentEvaluation();
      setState(() {
        _answerLetter = AnswerLetter.none;
        _indexQuestion++;
      });
      _timeToQuestion();
    } else if (_indexQuestion >= widget.evaluation.question.length - 1 &&
        !_lastQuestion) {
      _cancelTimer();
      _performStudentEvaluation();
      _evaluationStudent.listQuestionAnswer = _listQuestionAnswer;
      _evaluationStudent.finalDateTime = Timestamp.now();
      _lastQuestion = true;
      _saveStudentEvaluation(_evaluationStudent);
    }
  }

  void _performStudentEvaluation() async {
    if (_evaluationStudent == null) {
      final evaluationData = widget.evaluation;
      _evaluationStudent = EvaluationStudentModel();
      _evaluationStudent.initialDateTime = Timestamp.now();
      _evaluationStudent.evaluationId = evaluationData.id;
      _evaluationStudent.evaluationTitle = evaluationData.title;
      _evaluationStudent.evaluationDiscipline = evaluationData.discipline;
      _evaluationStudent.evaluationCode = evaluationData.code;
      _evaluationStudent.user = await _viewModelUser.getCurrentUser();
      _evaluationStudent.grade = 0.0;
    } else {
      final questionData = widget.evaluation.question[_indexQuestion];
      final userAnswer = _answerLetter.toString().split('.').last;
      final userFinalAnswer = userAnswer == 'none' ? 'E' : userAnswer;
      _evaluationStudent.grade += userFinalAnswer == questionData.rightAnswer
          ? (1 * questionData.difficulty)
          : 0;

      _questionAnswers = QuestionAnswersModel(
        questionId: questionData.id,
        bncc: questionData.bncc,
        description: questionData.description,
        answerOptions: questionData.answerOptions,
        difficulty: questionData.difficulty,
        questionType: questionData.questionType,
        rightAnswer: questionData.rightAnswer,
        tip: questionData.tip,
        studentAnswer: userFinalAnswer,
      );
      _listQuestionAnswer.add(_questionAnswers);
    }
  }

  void _cancelTimer() {
    if (_timerToCancel != null) {
      _timerToCancel.cancel();
      _timerToCancel = null;
    }
  }

  void _timeToQuestion() {
    _cancelTimer();

    int _counterSeconds =
        widget.evaluation.question[_indexQuestion].responseTime;
    _timerToCancel = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counterSeconds >= 0) {
        setState(() {
          _timeToResponse = (_counterSeconds /
                  widget.evaluation.question[_indexQuestion].responseTime)
              .toPrecision(2);
        });
        _timeToAnswer = _counterSeconds;
        _counterSeconds--;
      } else {
        _cancelTimer();
        _nextQuestion();
      }
    });
  }

  Future<void> _saveStudentEvaluation(
      EvaluationStudentModel evaluationStudent) async {
    Widget userNota = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: CircularPercentIndicator(
        radius: 188,
        lineWidth: 4.0,
        percent: 1.0,
        animation: false,
        backgroundColor: greenBrightColor,
        progressColor: greenBrightColor,
        center: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline3.copyWith(
                color: greenBrightColor,
                fontWeight: FontWeight.bold,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              _evaluationStudent.grade.toString(),
            ),
          ),
        ),
      ),
    );

    Widget circularProgress = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: CircularPercentIndicator(
        radius: 150.0,
        lineWidth: 4.0,
        percent: 1.0,
        restartAnimation: true,
        animation: true,
        animationDuration: 10500,
        center: Icon(
          CustomIcon.icon_avalia,
          size: 80.0,
          color: greenBrightColor,
        ),
        backgroundColor: whiteColor,
        progressColor: greenBrightColor,
      ),
    );
    Widget button = RaisedButton(
      onPressed: () {
        Navigator.of(context)..pop()..pop()..pop()..pop();
      },
      color: whiteColor,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: yellowDeepColor,
        ),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: yellowDeepColor,
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ir para o Menu Principal'),
        ),
      ),
    );

    showUserGrade(
        'Aguarde! Estamos calculando a sua nota...', circularProgress, null);
    setLoading(true);
    await Future.delayed(
      Duration(seconds: 5),
      () => _viewModelEvaluation.saveStudentEvaluation(evaluationStudent),
    );
    switch (_viewModelEvaluation.loadingStatus) {
      case LoadingStatus.completed:
        await showUserGrade(
          'Parabéns,\nsua nota foi: ',
          userNota,
          button,
        );
        setLoading(false);
        break;
      case LoadingStatus.error:
        await showUserGrade(
          'Erro ao processar a nota',
          Text(
              'Houve um erro ao processar a sua nota.\nPor favor, entre em contato com o seu professor!'),
          button,
        );
        setLoading(false);
        break;

      default:
        setLoading(false);
    }
  }

  Future<void> showUserGrade(
      String title, Widget content, Widget button) async {
    return LayoutAlert.customAlert(
      title: title,
      color: yellowDeepColor,
      context: context,
      message: content,
      actionButtons: button,
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    _performStudentEvaluation();
    _timeToQuestion();
    super.initState();
  }

  @override
  void dispose() {
    if (_timerToCancel != null) {
      _timerToCancel.cancel();
      _timerToCancel = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.evaluation.question[_indexQuestion];
    // final questionsNumberOfCharacters =
    //     (widget.evaluation.question[_indexQuestion].description.length)
    //         .toDouble();
    final numberOfQuestions = widget.evaluation.question.length;
    final deviceSize = MediaQuery.of(context).size;
    // final timeToAnswer =
    //     widget.evaluation.question[_indexQuestion].responseTime;
    //final totalTime = Duration(seconds: timeToAnswer);
    // final arrayTime = totalTime.toString().split(':');
    // final formattedTime = int.parse(arrayTime[1]) == 0
    //     ? '${double.parse(arrayTime[2]).truncate()}'
    //     : '${arrayTime[1]}min${double.parse(arrayTime[2]).truncate()}s';

    final numberFormat = NumberFormat('00');

    final _title = Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${numberFormat.format(_indexQuestion + 1)}/${numberFormat.format(numberOfQuestions)}',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          Container(
            width: deviceSize.width * 0.4,
            padding: const EdgeInsets.only(left: 52.0),
            child: CircularPercentIndicator(
              radius: 55,
              percent: _timeToResponse,
              center: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((_timeToAnswer).toString()),
              ),
              backgroundColor: whiteColor,
              progressColor: greenDeepColor,
              animation: false,
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
                unselectedWidgetColor: yellowDeepColor,
                toggleableActiveColor: yellowDeepColor,
              ),
              child: Radio(
                value: answerLetter,
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
                    child: Text(letter),
                  ),
                  Container(
                    width: deviceSize.width * 0.67,
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: yellowDeepColor,
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
            question.answerOptions['A'],
          ),
          _buildOptions(
            AnswerLetter.B,
            'B - ',
            question.answerOptions['B'],
          ),
          _buildOptions(
            AnswerLetter.C,
            'C - ',
            question.answerOptions['C'],
          ),
          _buildOptions(
            AnswerLetter.D,
            'D - ',
            question.answerOptions['D'],
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
            color: (_timeToResponse <= 0.4 &&
                    (_timeToResponse * 100).toInt().isOdd)
                ? redColor
                : yellowDeepColor,
            context: context,
            onPressedButtonOne: _nextQuestion,
          ),
        ],
      ),
    );

    final _question = Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 24.0, right: 24.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: yellowDeepColor,
                ),
            child: AutoSizeText(
              '${_indexQuestion + 1}. ',
              wrapWords: false,
              maxLines: 2,
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
                wrapWords: false,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );

    final _questionnaire = Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _question,
          _answersOptions,
        ],
      ),
    );

    final _content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: deviceSize.height * 0.75,
        maxHeight: deviceSize.height * 0.87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title,
          _questionnaire,
          _button,
        ],
      ),
    );

    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'Questões',
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
