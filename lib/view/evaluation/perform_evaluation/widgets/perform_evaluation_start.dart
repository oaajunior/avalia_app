import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../view/layout/layout_page.dart';
import '../../../../view/evaluation/perform_evaluation/perform_evaluation_prepare_view.dart';
import '../../../../res/colors.dart';
import '../../../../view/layout/layout_alert.dart';
import '../../../../view/layout/layout_buttons.dart';

class PerformEvaluationStart extends StatelessWidget {
  static const routeName = '/perform_evaluation_start';
  final _evaluation;
  final _itemSize = AutoSizeGroup();
  PerformEvaluationStart(this._evaluation);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;

    Future<void> showMessageToUser(
      String title,
      String message,
    ) {
      final customMessage = Text(
        message,
        textAlign: TextAlign.center,
      );

      final button = RaisedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        color: yellowDeepColor,
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
        colorTitle: yellowDeepColor,
        color: blackSoftColor,
        context: context,
        actionButtons: button,
      );
    }

    Future<bool> _isDateEvaluationRight() async {
      if (_evaluation.finalDate.toDate().isBefore(DateTime.now())) {
        await showMessageToUser('Período da Avaliação',
            'O período da avaliação já foi encerrado. Verifique com o seu professor!');
        return false;
      } else if (_evaluation.initialDate.toDate().isAfter(DateTime.now())) {
        await showMessageToUser('Período da Avaliação',
            'O período da avaliação ainda não foi iniciado. Verifique com o seu professor!');
        return false;
      }
      return true;
    }

    void _goToPage() async {
      if (await _isDateEvaluationRight()) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          PerformEvaluationPrepareView.routeName,
          arguments: _evaluation,
        );
      }
    }

    Widget _buildText(String textHeader, String textField, double widthValue) {
      return Container(
        width: _deviceSize.width * 0.9,
        padding: const EdgeInsets.only(
          bottom: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: _deviceSize.width * widthValue,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                child: AutoSizeText(
                  textHeader,
                  group: _itemSize,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
            Container(
              width: _deviceSize.width * widthValue,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black54,
                    ),
                child: AutoSizeText(
                  textField,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  strutStyle: StrutStyle.fromTextStyle(
                    Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _evaluationInformation = Container(
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).accentColor,
      ),
      width: _deviceSize.width * 0.9,
      height: _deviceSize.height * 0.72,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildText(
                'Disciplina: ',
                _evaluation.discipline,
                0.8,
              ),
              _buildText(
                'Ano Escolar: ',
                '${_evaluation.schoolYear.toString()}º',
                0.8,
              ),
              _buildText(
                'Turma: ',
                _evaluation.team,
                0.8,
              ),
              _buildText(
                'Nº de Questões: ',
                _evaluation.totalQuestions.toString(),
                0.8,
              ),
              _buildText(
                'Tempo Estimado: ',
                _evaluation.totalTime,
                0.8,
              ),
              _buildText(
                'Data Inicio: ',
                DateFormat('dd/MM/yy').format(_evaluation.initialDate.toDate()),
                0.8,
              ),
              _buildText(
                'Hora Inicio: ',
                DateFormat('Hm').format(_evaluation.initialDate.toDate()),
                0.8,
              ),
              _buildText(
                'Data Final ',
                DateFormat('dd/MM/yy').format(
                  _evaluation.finalDate.toDate(),
                ),
                0.8,
              ),
              _buildText(
                'Hora Final: ',
                DateFormat('Hm').format(_evaluation.finalDate.toDate()),
                0.8,
              ),
            ],
          ),
        ),
      ),
    );

    final _buttons = Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: LayoutButtons.customRaisedButtons(
                  textRaisedButtonOne: 'Cancelar',
                  color: yellowDeepColor,
                  context: context,
                  shortButton: true,
                  onPressedButtonOne: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: LayoutButtons.customRaisedButtons(
                    textRaisedButtonOne: 'Iniciar',
                    color: yellowDeepColor,
                    context: context,
                    shortButton: true,
                    onPressedButtonOne: _goToPage),
              ),
            ],
          ),
        ],
      ),
    );

    final _content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: _deviceSize.height * 0.80,
        maxHeight: _deviceSize.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _evaluationInformation,
          _buttons,
        ],
      ),
    );
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'Informações Gerais',
      context: context,
      color: yellowDeepColor,
      content: _content,
    );
  }
}
