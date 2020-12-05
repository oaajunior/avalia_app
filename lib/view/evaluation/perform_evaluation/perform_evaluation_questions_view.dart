import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import '../../../view/evaluation/perform_evaluation/widgets/evaluation_quesitonnaire_view.dart';

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
  final _viewModelUser = UserAccessViewModel();
  final _viewModelEvaluation = PerformEvaluationViewModel();
  Map<AnswerLetter, bool> _answerLetter = Map<AnswerLetter, bool>();
  EvaluationStudentModel _evaluationStudent;
  List<QuestionAnswersModel> _listQuestionAnswer = List<QuestionAnswersModel>();
  QuestionAnswersModel _questionAnswers;
  Timer _timerToCancel;
  final _timeToResponse = ValueNotifier<double>(0.0);
  int _indexQuestion = 0;
  bool _lastQuestion = false;
  bool _isLoading = false;
  int _timeToAnswer = 0;
  bool _isClickedInOptions = false;

  bool getIsClickedInOptions() {
    return _isClickedInOptions;
  }

  void setIsClickedInOptions(bool value) {
    _isClickedInOptions = value;
  }

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  bool getIsLoading() {
    return _isLoading;
  }

  bool getAnswerLetter(AnswerLetter letter) {
    return _answerLetter[letter];
  }

  void setAnswerLetter(AnswerLetter letter, bool value) {
    setState(() {
      _answerLetter[letter] = value;
    });
  }

  void _turnAllAnswerLetterToFalse() {
    _answerLetter = {
      AnswerLetter.A: false,
      AnswerLetter.B: false,
      AnswerLetter.C: false,
      AnswerLetter.D: false,
      AnswerLetter.E: false,
      AnswerLetter.none: false,
    };
  }

  void _nextQuestion() {
    if (_indexQuestion < widget.evaluation.question.length - 1) {
      _performStudentEvaluation();
      setState(() {
        _turnAllAnswerLetterToFalse();
        setIsClickedInOptions(false);
        _indexQuestion++;
      });
      _timeToQuestion();
    } else if (_indexQuestion >= widget.evaluation.question.length - 1 &&
        !_lastQuestion) {
      _cancelTimer();
      _performStudentEvaluation();
      _evaluationStudent.listQuestionAnswers = _listQuestionAnswer;

      _lastQuestion = true;
      _saveStudentEvaluation(_evaluationStudent);
    }
  }

  void _performStudentEvaluation() async {
    if (_evaluationStudent == null) {
      final evaluationData = widget.evaluation;
      final user = await _viewModelUser.getUserData();
      final tempName = user.surName.split(' ');
      final userName = user.name + ' ' + tempName.first;
      _evaluationStudent = EvaluationStudentModel();
      _evaluationStudent.initialDateTime = evaluationData.initialDate;
      _evaluationStudent.finalDateTime = evaluationData.finalDate;
      _evaluationStudent.evaluationId = evaluationData.id;
      _evaluationStudent.evaluationTitle = evaluationData.title;
      _evaluationStudent.evaluationDiscipline = evaluationData.discipline;
      _evaluationStudent.evaluationCode = evaluationData.code;
      _evaluationStudent.userId = user.id;
      _evaluationStudent.userName = userName;
      _evaluationStudent.grade = 0.0;
    } else {
      final questionData = widget.evaluation.question[_indexQuestion];
      AnswerLetter answerStudent;
      _answerLetter.forEach((key, value) {
        if (value == true) {
          answerStudent = key;
        }
      });
      _evaluationStudent.grade += answerStudent == questionData.rightAnswer
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
        studentAnswer: answerStudent,
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
        _timeToResponse.value = (_counterSeconds /
                widget.evaluation.question[_indexQuestion].responseTime)
            .toPrecision(2);

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
    Widget userGrade = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: CircularPercentIndicator(
        radius: 150,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
        Navigator.of(context)..pop()..pop()..pop();
      },
      color: whiteColor,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          width: 1.5,
          style: BorderStyle.solid,
          color: yellowDeepColor,
        ),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: yellowDeepColor,
              fontWeight: FontWeight.w700,
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Ir para o Menu Principal'),
        ),
      ),
    );

    await showAwaitMessageForGrade(
        'Aguarde! Estamos calculando a sua nota...', circularProgress, null);
    setLoading(true);
    await _viewModelEvaluation.saveStudentEvaluation(evaluationStudent);
    switch (_viewModelEvaluation.loadingStatus) {
      case LoadingStatus.completed:
        setLoading(false);
        await showUserGrade(
          'Sua nota foi: ',
          userGrade,
          button,
        );
        break;
      case LoadingStatus.error:
        setLoading(false);
        await showUserGrade(
          'Erro ao processar a nota',
          Text(
              'Houve um erro ao processar a sua nota.\nPor favor, entre em contato com o seu professor!'),
          button,
        );
        break;

      default:
        setLoading(false);
    }
  }

  Future<void> showAwaitMessageForGrade(
      String title, Widget content, Widget button) async {
    return LayoutAlert.customAlert(
      title: title,
      color: yellowDeepColor,
      context: context,
      message: content,
      actionButtons: button,
      countTimer: true,
      barrierDismissible: false,
    );
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
    _turnAllAnswerLetterToFalse();
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
    _timeToResponse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _question = widget.evaluation.question[_indexQuestion];
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
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${numberFormat.format(_indexQuestion + 1)}/${numberFormat.format(numberOfQuestions)}',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Container(
            width: deviceSize.width * 0.4,
            padding: const EdgeInsets.only(left: 40.0),
            child: ValueListenableBuilder(
              valueListenable: _timeToResponse,
              builder: (context, value, child) => CircularPercentIndicator(
                radius: 42,
                percent: value,
                center: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle1.copyWith(),
                    child: Text((_timeToAnswer).toString()),
                  ),
                ),
                backgroundColor: whiteColor,
                progressColor: greenDeepColor,
                animation: false,
              ),
            ),
          ),
        ],
      ),
    );

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: _timeToResponse,
            builder: (context, value, child) =>
                LayoutButtons.customRaisedButtons(
              textRaisedButtonOne: 'Próxima',
              color: (value <= 0.4 && (value * 100).toInt().isOdd)
                  ? redColor
                  : yellowDeepColor,
              context: context,
              onPressedButtonOne: _nextQuestion,
            ),
          ),
        ],
      ),
    );

    final questionnaire = EvaluationQuestionnaireView.performEvaluation(
      _indexQuestion,
      _question,
      getAnswerLetter,
      setAnswerLetter,
      true,
      yellowDeepColor,
      _turnAllAnswerLetterToFalse,
      getIsClickedInOptions,
      setIsClickedInOptions,
    );

    final _content = SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: deviceSize.height * 0.72,
          maxHeight: deviceSize.height * 0.95,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _title,
            questionnaire,
            _button,
          ],
        ),
      ),
    );

    return LayoutPage.render(
      hasHeader: false,
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
