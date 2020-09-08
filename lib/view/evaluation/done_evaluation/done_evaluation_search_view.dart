import 'package:avalia_app/view/evaluation/done_evaluation/done_evaluation_list_view.dart';
import 'package:flutter/material.dart';

import '../../../res/colors.dart';
import '../../layout/layout_page.dart';
import './widgets/done_evaluation_search_detail.dart';
import '../../layout/layout_alert.dart';
import '../../../model/evaluation_student/evaluation_student_model.dart';
import '../../../view_model/done_evaluation_view_model.dart';
import '../../../utils/loading_status.dart';

class DoneEvaluationsSearchView extends StatefulWidget {
  static const routeName = 'done_evaluation';
  final String title;

  DoneEvaluationsSearchView(this.title);

  @override
  _DoneEvaluationsSearchViewState createState() =>
      _DoneEvaluationsSearchViewState();
}

class _DoneEvaluationsSearchViewState extends State<DoneEvaluationsSearchView> {
  final _viewModel = DoneEvaluationViewModel();
  List<EvaluationStudentModel> _listEvaluationStudent;
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
    Navigator.of(context)
        .pushNamed(DoneEvaluationListView.routeName, arguments: [
      widget.title,
      _listEvaluationStudent,
    ]);
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

  void _searchForStudentEvaluation(
      DateTime initialDate, DateTime finalDate) async {
    setLoading(true);
    _listEvaluationStudent = await _viewModel.getStudentEvaluation(
        initialDate: initialDate, finalDate: finalDate);

    switch (_viewModel.loadingStatus) {
      case LoadingStatus.completed:
        setLoading(false);
        _goToPage();
        break;

      case LoadingStatus.empty:
        setLoading(false);
        await showMessageToUser(
            'Avaliação não encontrada',
            'Nenhuma avaliação foi localizada para o período informado. Por favor, tente um novo período!',
            context);
        break;

      case LoadingStatus.error:
        if (_viewModel.exception != null) {
          setLoading(false);
          showMessageToUser(
            widget.title.replaceAll('\n', ' '),
            _viewModel.exception.toString(),
            context,
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
      context: context,
      headerTitle: widget.title.replaceAll('\n', ' '),
      color: greenDeepColor,
      content: DoneEvaluationDetail(getIsLoading, _searchForStudentEvaluation),
    );
  }
}
