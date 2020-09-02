import 'package:avalia_app/view/evaluation/perform_evaluation/widgets/perform_evaluation_prepare_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../view/layout/layout_alert.dart';
import '../../layout/layout_page.dart';
import '../../../view_model/perform_evaluation_view_model.dart';
import 'widgets/perform_evaluation_detail.dart';
import '../../../utils/loading_status.dart';
import '../../../res/colors.dart';
import '../../../model/evaluation/evaluation_model.dart';

class PerformEvaluationView extends StatefulWidget {
  static const routeName = '/realizar_avaliacao';
  final String title;

  PerformEvaluationView(this.title);

  @override
  _PerformEvaluationViewState createState() => _PerformEvaluationViewState();
}

class _PerformEvaluationViewState extends State<PerformEvaluationView> {
  final _viewModel = PerformEvaluationViewModel();
  EvaluationModel _evaluation;
  bool _isLoading = false;

  void setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  bool getIsLoading() {
    return _isLoading;
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

  Widget _buildText(String textHeader, String textField) {
    return Row(
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
          child: Text(
            textHeader,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 28,
        ),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
              ),
          child: Text(
            textField,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

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

  Future<void> _buildEvaluation(EvaluationModel _evaluation) {
    final message = FittedBox(
      alignment: Alignment.topLeft,
      fit: BoxFit.contain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildText(
            'Disciplina: ',
            _evaluation.discipline,
          ),
          _buildText(
            'Ano Escolar: ',
            '${_evaluation.schoolYear.toString()}º',
          ),
          _buildText(
            'Turma: ',
            _evaluation.team,
          ),
          _buildText(
            'Quantidade de Questões: ',
            _evaluation.totalQuestions.toString(),
          ),
          _buildText(
            'Tempo Mínimo: ',
            _evaluation.totalTime,
          ),
          _buildText(
            'Data Inicio: ',
            DateFormat('dd/MM/yy').format(_evaluation.initialDate.toDate()),
          ),
          _buildText(
            'Hora Inicio: ',
            DateFormat('Hm').format(_evaluation.initialDate.toDate()),
          ),
          _buildText(
            'Data Final ',
            DateFormat('dd/MM/yy').format(_evaluation.finalDate.toDate()),
          ),
          _buildText(
            'Hora Final: ',
            DateFormat('Hm').format(_evaluation.finalDate.toDate()),
          ),
        ],
      ),
    );

    final buttons = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
            child: Text('Cancelar'),
          ),
          color: yellowBrightColor,
          elevation: 0,
        ),
        SizedBox(
          width: 32,
        ),
        RaisedButton(
          onPressed: _goToPage,
          color: yellowDeepColor,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
            child: Text('Iniciar'),
          ),
        )
      ],
    );

    final alert = LayoutAlert.customAlert(
      title: widget.title.replaceAll('\n', ' '),
      color: yellowDeepColor,
      context: context,
      message: message,
      actionButtons: buttons,
      barrierDismissible: false,
    );
    return alert;
  }

  void _searchForEvaluationCode(String codigo) async {
    setLoading(true);
    _evaluation = await _viewModel.getEvaluation(codigo);

    switch (_viewModel.loadingStatus) {
      case LoadingStatus.completed:
        setLoading(false);
        await _buildEvaluation(_evaluation);
        break;

      case LoadingStatus.empty:
        setLoading(false);
        await showMessageToUser('Avaliação não encontrada',
            'Não foi localizada uma avaliação para o código informado. Por favor, verifique o código digitado!');
        break;

      case LoadingStatus.error:
        if (_viewModel.exception != null) {
          setLoading(false);
          showMessageToUser(
            widget.title.replaceAll('\n', ' '),
            _viewModel.exception.toString(),
          );
        }
        break;
      default:
        setLoading(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'Realizar Avaliação',
      context: context,
      color: yellowDeepColor,
      content: PerformEvaluationDetail(getIsLoading, _searchForEvaluationCode),
    );
  }
}
