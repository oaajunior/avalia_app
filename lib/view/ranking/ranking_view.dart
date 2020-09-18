import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../model/evaluation_student/evaluation_student_model.dart';
import '../../view_model/done_evaluation_view_model.dart';
import '../../res/colors.dart';
import '../../view/layout/layout_buttons.dart';
import '../../res/custom_icon.dart';

import '../layout/layout_page.dart';

class RankingView extends StatefulWidget {
  static const routeName = 'ranking';
  final EvaluationStudentModel _studentEvaluation;

  RankingView(this._studentEvaluation);

  @override
  _RankingViewState createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  final _viewModelEvaluation = DoneEvaluationViewModel();
  ScrollController _controller;
  bool hasManyItemsToShow = false;

  void _setScrollBar() {
    if (!hasManyItemsToShow)
      setState(() {
        hasManyItemsToShow = true;
      });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    void _goToPage() {
      Navigator.of(context)..pop()..pop()..pop()..pop();
    }

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
            textRaisedButtonOne: 'Ir para o menu principal',
            color: purpleDeepColor,
            context: context,
            onPressedButtonOne: _goToPage,
          ),
        ],
      ),
    );

    final _header = Container(
      width: _deviceSize.width * 0.85,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          Icon(
            CustomIcon.icon_ranking,
            color: purpleDeepColor,
            size: 55,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: purpleDeepColor,
                            fontWeight: FontWeight.w700,
                          ),
                      child: AutoSizeText(
                        widget._studentEvaluation.evaluationDiscipline,
                        wrapWords: false,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: purpleDeepColor,
                            ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(
                            widget._studentEvaluation.initialDateTime.toDate(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final _columnTitles = Container(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: purpleDeepColor,
                ),
            child: Text('Posição'),
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: purpleDeepColor,
                ),
            child: Text('Nome'),
          ),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: purpleDeepColor,
                ),
            child: Text('Nota'),
          ),
        ],
      ),
    );

    Widget _buildPosition(int position, bool currentStudent) {
      return Container(
        width: _deviceSize.width * 0.12,
        height: _deviceSize.width * 0.12,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: currentStudent ? purpleDeepColor : purpleSoftColor,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: currentStudent ? purpleDeepColor : purpleSoftColor,
                ),
            child: AutoSizeText(
              '${position.toString()}º',
            ),
          ),
        ),
      );
    }

    Widget _buildRanking(List<EvaluationStudentModel> listEvaluation) {
      List<Widget> studentEvaluationListWidget = List<Widget>();
      bool studentBetweenThree = false;
      bool currentStudent = false;
      Widget actualStudentPosition;
      int qtdStudents = 0;

      for (var i = 0; i < listEvaluation.length; i++) {
        if (listEvaluation[i].position > 3) {
          break;
        }
        qtdStudents++;
        if (listEvaluation[i].userId == widget._studentEvaluation.userId) {
          studentBetweenThree = true;
        }

        if (listEvaluation[i].userId == widget._studentEvaluation.userId) {
          currentStudent = true;
        } else {
          currentStudent = false;
        }
        studentEvaluationListWidget.add(
          Padding(
            padding: const EdgeInsets.only(
              top: 7.0,
              right: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPosition(listEvaluation[i].position, currentStudent),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color:
                            currentStudent ? purpleDeepColor : purpleSoftColor,
                      ),
                  child: AutoSizeText(
                    listEvaluation[i].userName,
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color:
                            currentStudent ? purpleDeepColor : purpleSoftColor,
                      ),
                  child: Text(
                    listEvaluation[i].grade.toString(),
                  ),
                ),
              ],
            ),
          ),
        );
        if (qtdStudents >= 6) {
          Future.delayed(Duration.zero, () => _setScrollBar());
        }
      }

      if (!studentBetweenThree) {
        final actualStudent = listEvaluation.firstWhere(
            (element) => element.userId == widget._studentEvaluation.userId);
        // print('name ${actualStudent.userName}');
        // print('nota ${actualStudent.grade}');
        // print('posição ${actualStudent.position}');
        // print('totalStudents ${listEvaluation.length}');

        actualStudentPosition = Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: purpleDeepColor,
                  fontWeight: FontWeight.w600,
                ),
            child: AutoSizeText(
              actualStudent.percentStudentGrade <= 75.0
                  ? actualStudent.grade <= 3.0
                      ? '${actualStudent.userName}, parece que sua nota não foi tão boa :( \n Mas ela está entre ${actualStudent.percentStudentGrade}% das melhores notas. Continue estudando!'
                      : '${actualStudent.userName}, sua nota está entre ${actualStudent.percentStudentGrade}% das melhores notas ;)'
                  : actualStudent.grade <= 3.0
                      ? '${actualStudent.userName}, parece que sua nota não foi tão boa :( \n Continue estudando!'
                      : '${actualStudent.userName}, a sua colocação parece não ter sido tão boa. Mas você está chegando lá ;) \nContinue estudando!',
              wrapWords: false,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...studentEvaluationListWidget,
            if (!studentBetweenThree) actualStudentPosition,
          ],
        ),
      );
    }

    Widget _buildRankingContent() {
      return Container(
        height: _deviceSize.height * 0.50,
        child: DraggableScrollbar.rrect(
          alwaysVisibleScrollThumb: hasManyItemsToShow,
          heightScrollThumb: 38.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          backgroundColor: purpleSoftColor,
          controller: _controller,
          child: ListView(
            controller: _controller,
            children: [
              FutureBuilder(
                future: _viewModelEvaluation.getTopStudentEvaluation(
                    code: widget._studentEvaluation.evaluationCode,
                    userId: widget._studentEvaluation.userId),
                builder: (ctx, dataSnapshot) {
                  if (ConnectionState.waiting == dataSnapshot.connectionState) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: whiteColor,
                      ),
                    );
                  } else if (!dataSnapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 40.0,
                        horizontal: 16.0,
                      ),
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: blackSoftColor,
                            ),
                        child: Text('Não há avaliações para exibir!'),
                      ),
                    );
                  } else {
                    return _buildRanking(
                      (dataSnapshot.data as List<EvaluationStudentModel>),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    final _ranking = Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: _deviceSize.width * 0.9,
      height: _deviceSize.height * 0.73,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header,
          _columnTitles,
          _buildRankingContent(),
        ],
      ),
    );

    final content = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: _deviceSize.height * 0.86,
        maxWidth: _deviceSize.width * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ranking,
          _button,
        ],
      ),
    );
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'Ranking',
      color: purpleDeepColor,
      context: context,
      content: content,
    );
  }
}
