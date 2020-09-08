import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../model/evaluation_student/evaluation_student_model.dart';
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

  @override
  void initState() {
    _title = widget.arguments[0];
    _studentEvaluation = widget.arguments[1];
    super.initState();
  }

  void _goToPage(int index) async {
    Navigator.of(context).pushNamed(
      DoneEvaluationQuestionAnswersView.routeName,
      arguments: _studentEvaluation[index],
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
        width: 80,
        fit: BoxFit.cover,
      ),
    );

    Widget _buildInformation(int index) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: greenDeepColor,
                    fontWeight: FontWeight.bold,
                  ),
              child: AutoSizeText(
                _studentEvaluation[index].evaluationDiscipline,
                maxLines: 2,
                wrapWords: false,
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: greenDeepColor,
                    //fontWeight: FontWeight.bold,
                  ),
              child: Text(
                DateFormat('dd/MM/yyyy').format(
                  _studentEvaluation[index].initialDateTime.toDate(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildGrade(int index) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8.0, right: 4.0),
        child: CircularPercentIndicator(
          radius: 70,
          lineWidth: 2.0,
          percent: 1.0,
          animation: false,
          backgroundColor: greenBrightColor,
          progressColor: greenBrightColor,
          center: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
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
      return GestureDetector(
        onTap: () => _goToPage(index),
        child: Card(
          shape: Theme.of(context).cardTheme.shape,
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: _deviceSize.width * 0.9,
            height: _deviceSize.height * 0.2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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

    final _listView = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: _deviceSize.width * 0.95,
        maxHeight: _deviceSize.height * 0.25,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 24.0),
        child: ListView.builder(
          itemCount: _studentEvaluation.length,
          itemBuilder: (ctx, index) => _buildListItem(index),
        ),
      ),
    );

    return LayoutPage.render(
      headerTitle: _title,
      hasHeaderButtons: true,
      hasHeader: true,
      context: context,
      color: greenDeepColor,
      content: _listView,
    );
  }
}
