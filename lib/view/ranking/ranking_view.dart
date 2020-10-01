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
  final hasManyItemsToShow = ValueNotifier<bool>(false);
  AutoSizeGroup _itemListSize = AutoSizeGroup();
  Widget _studentPosition;
  bool _studentBetweenThree = false;
  bool _currentStudent = false;

  void _setScrollBar() {
    if (!hasManyItemsToShow.value) {
      hasManyItemsToShow.value = true;
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    hasManyItemsToShow.dispose();
    super.dispose();
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
                Container(
                  width: _deviceSize.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                color: purpleDeepColor,
                                fontWeight: FontWeight.w700,
                              ),
                          child: AutoSizeText(
                            widget._studentEvaluation.evaluationDiscipline,
                            wrapWords: false,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: DefaultTextStyle(
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      color: purpleDeepColor,
                                    ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(
                                widget._studentEvaluation.createdAt.toDate(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // final _columnTitles = Container(
    //   padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    // DefaultTextStyle(
    //   style: Theme.of(context).textTheme.headline6.copyWith(
    //         color: purpleDeepColor,
    //       ),
    //   child: AutoSizeText(
    //     'Posição',
    //     group: _itemListSize,
    //   ),
    // ),
    // DefaultTextStyle(
    //         style: Theme.of(context).textTheme.headline6.copyWith(
    //               color: purpleDeepColor,
    //             ),
    //         child: AutoSizeText(
    //           'Nome',
    //           group: _itemListSize,
    //         ),
    //       ),
    //       DefaultTextStyle(
    //         style: Theme.of(context).textTheme.headline6.copyWith(
    //               color: purpleDeepColor,
    //             ),
    //         child: AutoSizeText(
    //           'Nota',
    //           group: _itemListSize,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    final _studentSection = Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        bottom: 8.0,
      ),
      width: _deviceSize.width * 0.85,
      height: _deviceSize.width * 0.08,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline5.copyWith(
              color: purpleDeepColor,
            ),
        child: AutoSizeText(
          'Sua posição:',
          group: _itemListSize,
          textAlign: TextAlign.left,
        ),
      ),
    );

    final _furtherStudentSection = Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        bottom: 16.0,
      ),
      width: _deviceSize.width * 0.85,
      height: _deviceSize.width * 0.1,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline5.copyWith(
              color: purpleDeepColor,
            ),
        child: AutoSizeText(
          'Demais posições:',
          group: _itemListSize,
          textAlign: TextAlign.left,
        ),
      ),
    );

    Widget _buildPosition(int position, bool currentStudent) {
      return Container(
        width: _deviceSize.width * 0.12,
        height: _deviceSize.width * 0.12,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: purpleBrightColor,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: purpleBrightColor,
                ),
            child: AutoSizeText(
              '${position.toString()}º',
              group: _itemListSize,
            ),
          ),
        ),
      );
    }

    Widget _buildRanking(List<EvaluationStudentModel> listEvaluation) {
      List<Widget> studentEvaluationListWidget = List<Widget>();

      int qtdStudents = 0;

      for (var i = 0; i < listEvaluation.length; i++) {
        if (listEvaluation[i].position > 3) {
          break;
        }
        qtdStudents++;

        if (listEvaluation[i].userId == widget._studentEvaluation.userId) {
          _studentBetweenThree = true;
          _currentStudent = true;
        } else {
          _currentStudent = false;
        }

        Widget actualStudent = Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 24.0, 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPosition(listEvaluation[i].position, _currentStudent),
              Container(
                width: _deviceSize.width * 0.5,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: purpleBrightColor,
                      ),
                  child: AutoSizeText(
                    listEvaluation[i].userName,
                    maxLines: 1,
                    group: _itemListSize,
                  ),
                ),
              ),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: purpleBrightColor,
                    ),
                child: AutoSizeText(
                  listEvaluation[i].grade.toString(),
                  group: _itemListSize,
                ),
              ),
            ],
          ),
        );
        studentEvaluationListWidget.add(actualStudent);
        if (_currentStudent) _studentPosition = actualStudent;

        if (qtdStudents > 4) {
          Future.delayed(Duration.zero, () => _setScrollBar());
        }
      }

      if (!_studentBetweenThree) {
        final actualStudent = listEvaluation.firstWhere(
            (element) => element.userId == widget._studentEvaluation.userId);
        // print('name ${actualStudent.userId}');
        // print('name ${actualStudent.userName}');
        // print('nota ${actualStudent.grade}');
        // print('posição ${actualStudent.position}');
        // print('totalStudents ${listEvaluation.length}');

        final userTempName = actualStudent.userName.split(" ");
        final userFirstName = userTempName[0];

        _studentPosition = Container(
          height: _deviceSize.height * 0.12,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 4.0,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: purpleBrightColor,
                  fontWeight: FontWeight.w600,
                ),
            child: AutoSizeText(
              actualStudent.percentStudentGrade <= 75.0
                  ? actualStudent.grade <= 3.0
                      ? '$userFirstName, parece que sua nota não foi tão boa :(  Continue estudando!'
                      : '$userFirstName, sua nota está entre ${actualStudent.percentStudentGrade}% das melhores notas ;)'
                  : actualStudent.grade <= 3.0
                      ? '$userFirstName, parece que sua nota não foi tão boa :(  Continue estudando!'
                      : '$userFirstName, a sua colocação parece não ter sido tão boa. Mas você está chegando lá ;)  Continue estudando!',
              wrapWords: false,
              maxLines: 3,
              group: _itemListSize,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Divider(
            indent: 16.0,
            endIndent: 24.0,
            color: purpleDeepColor,
          ),
          _studentSection,
          if (_studentPosition != null) _studentPosition,
          Divider(
            indent: 16.0,
            endIndent: 24.0,
            color: purpleDeepColor,
          ),
          _furtherStudentSection,
          Container(
            height: _studentBetweenThree
                ? _deviceSize.height * 0.33
                : _deviceSize.height * 0.29,
            child: ValueListenableBuilder(
              valueListenable: hasManyItemsToShow,
              builder: (context, value, child) => DraggableScrollbar.rrect(
                alwaysVisibleScrollThumb: value,
                heightScrollThumb: 30.0,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                backgroundColor: purpleDeepColor,
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    ...studentEvaluationListWidget,
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildRankingContent() {
      return FutureBuilder(
          future: _viewModelEvaluation.getTopStudentEvaluation(
              code: widget._studentEvaluation.evaluationCode,
              userId: widget._studentEvaluation.userId),
          builder: (ctx, dataSnapshot) {
            if (ConnectionState.waiting == dataSnapshot.connectionState) {
              return Container(
                height: _deviceSize.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: purpleDeepColor,
                  ),
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
          });
    }

    final _ranking = Container(
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).accentColor),
      width: _deviceSize.width * 0.9,
      height: _deviceSize.height * 0.72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _header,
          _buildRankingContent(),
        ],
      ),
    );

    final content = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: _deviceSize.height * 0.85,
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
      hasFirstButton: true,
      firstButtonIconClose: true,
      headerTitle: 'Ranking',
      color: purpleDeepColor,
      context: context,
      content: content,
    );
  }
}
