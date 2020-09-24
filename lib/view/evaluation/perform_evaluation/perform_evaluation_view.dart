import 'package:flutter/material.dart';

import '../../../view/layout/layout_alert.dart';
import '../../layout/layout_page.dart';
import '../../../view_model/perform_evaluation_view_model.dart';
import 'widgets/perform_evaluation_detail_view.dart';
import '../../../utils/loading_status.dart';
import '../../../res/colors.dart';
import '../../../model/evaluation/evaluation_model.dart';
import '../../../view/evaluation/perform_evaluation/widgets/perform_evaluation_start.dart';

class PerformEvaluationView extends StatefulWidget {
  static const routeName = '/perform_evaluation';
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

  void _goToPage() async {
    Navigator.of(context).pushNamed(
      PerformEvaluationStart.routeName,
      arguments: _evaluation,
    );
  }

  void _searchForEvaluationCode(String codigo) async {
    setLoading(true);
    _evaluation = await _viewModel.getEvaluation(codigo);

    switch (_viewModel.loadingStatus) {
      case LoadingStatus.completed:
        setLoading(false);
        _goToPage();
        break;

      case LoadingStatus.empty:
        setLoading(false);
        await showMessageToUser('Avaliação não encontrada',
            'Não foi localizada a avaliação para o código informado.');
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
      hasFirstButton: true,
      headerTitle: widget.title.replaceAll('\n', ' '),
      context: context,
      color: yellowDeepColor,
      content: SingleChildScrollView(
        child: PerformEvaluationDetailView(
          getIsLoading,
          _searchForEvaluationCode,
        ),
      ),
    );
  }
}
