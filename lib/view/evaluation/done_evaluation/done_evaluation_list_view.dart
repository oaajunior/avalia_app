import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../model/evaluation_student/evaluation_student_model.dart';
import '../../../view/layout/layout_alert.dart';
import '../../../res/colors.dart';
import '../../../view/layout/layout_page.dart';
import './done_evaluation_question_answers_view.dart';

class DoneEvaluationListView extends StatefulWidget {
  static const routeName = 'done_evaluation_list';

  final List<dynamic> arguments;
  DoneEvaluationListView(this.arguments);

  @override
  _DoneEvaluationListViewState createState() => _DoneEvaluationListViewState();
}

class _DoneEvaluationListViewState extends State<DoneEvaluationListView> {
  String _title;
  List<EvaluationStudentModel> _studentEvaluation;
  bool isFinalDateBeforeActualDate;
  DateTime actualDate;
  DateTime finalDate;
  @override
  void initState() {
    _title = widget.arguments[0];
    _studentEvaluation = widget.arguments[1];
    super.initState();
  }

  void _goToPage(int index) async {
    finalDate = _studentEvaluation[index].finalDateTime.toDate();
    actualDate = DateTime.now();
    isFinalDateBeforeActualDate = finalDate.isBefore(actualDate);
    if (!isFinalDateBeforeActualDate) {
      await showMessageToUser(
          'Avaliação aberta',
          'A avaliação ainda não terminou.\nPor favor, aguarde finalizar o tempo programado para a avaliação!',
          context);
      return;
    }
    Navigator.of(context).pushNamed(
      DoneEvaluationQuestionAnswersView.routeName,
      arguments: _studentEvaluation[index],
    );
  }

  Future<void> showMessageToUser(
    String title,
    String message,
    BuildContext context,
  ) {
    final customMessage = Text(
      message,
      textAlign: TextAlign.center,
    );

    final button = RaisedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      color: greenDeepColor,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
        child: Text(
          'Ok',
          textAlign: TextAlign.center,
        ),
      ),
    );

    return LayoutAlert.customAlert(
      title: title,
      message: customMessage,
      colorTitle: greenDeepColor,
      color: blackSoftColor,
      context: context,
      actionButtons: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    final _image = ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
      ),
      child: Image.asset(
        'lib/res/images/avalia_evaluation_biology.png',
        height: _deviceSize.height * 0.2,
        width: _deviceSize.height * 0.1,
        fit: BoxFit.cover,
      ),
    );

    Widget _buildInformation(int index) {
      finalDate = _studentEvaluation[index].finalDateTime.toDate();
      actualDate = DateTime.now();
      isFinalDateBeforeActualDate = finalDate.isBefore(actualDate);
      return Container(
        width: _deviceSize.width * 0.53,
        padding: const EdgeInsets.only(left: 4.0, top: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: greenDeepColor,
                  ),
              child: AutoSizeText(
                _studentEvaluation[index].evaluationDiscipline,
                maxLines: 1,
                wrapWords: false,
                //group: _itemListSize,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: isFinalDateBeforeActualDate
                          ? greenDeepColor
                          : redColor),
                  child: AutoSizeText(
                    DateFormat('dd/MM/yyyy').format(
                      _studentEvaluation[index].finalDateTime.toDate(),
                    ),
                    maxLines: 1,
                    wrapWords: false,
                    //group: _itemListSize,
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: isFinalDateBeforeActualDate
                            ? greenDeepColor
                            : redColor,
                      ),
                  child: Text('-'),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: isFinalDateBeforeActualDate
                            ? greenDeepColor
                            : redColor,
                      ),
                  child: AutoSizeText(
                    DateFormat.Hm().format(
                      _studentEvaluation[index].finalDateTime.toDate(),
                    ),
                    maxLines: 1,
                    wrapWords: false,
                    //group: _itemListSize,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildGrade(int index) {
      return Container(
        padding: const EdgeInsets.only(
          left: 1.0,
        ),
        child: CircularPercentIndicator(
          radius: 55,
          lineWidth: 2.0,
          percent: 1.0,
          animation: false,
          backgroundColor: greenBrightColor,
          progressColor: greenBrightColor,
          center: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: greenBrightColor,
                  fontWeight: FontWeight.bold,
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                _studentEvaluation[index].grade.toString(),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildListItem(int index) {
      return InkWell(
        onTap: () => _goToPage(index),
        child: Card(
          shape: Theme.of(context).cardTheme.shape,
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: _deviceSize.width * 0.9,
            height: _deviceSize.height * 0.18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _image,
                _buildInformation(index),
                _buildGrade(index),
              ],
            ),
          ),
        ),
      );
    }

    final _content = Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      height: _deviceSize.height * 0.85,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 32.0),
        itemCount: _studentEvaluation.length,
        itemExtent: _deviceSize.height * 0.15,
        itemBuilder: (ctx, index) => _buildListItem(index),
      ),
    );

    return LayoutPage.render(
      headerTitle: _title,
      hasFirstButton: true,
      hasHeader: true,
      context: context,
      color: greenDeepColor,
      content: _content,
    );
  }
}
