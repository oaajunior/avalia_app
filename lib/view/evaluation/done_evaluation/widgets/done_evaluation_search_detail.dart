import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../layout/layout_buttons.dart';
import '../../../layout/layout_text_fields.dart';
import '../../../../res/colors.dart';
import '../../../layout/layout_alert.dart';

class DoneEvaluationDetail extends StatefulWidget {
  final Function isLoading;
  final Function searchForStudentEvaluation;
  DoneEvaluationDetail(this.isLoading, this.searchForStudentEvaluation);
  @override
  _DoneEvaluationDetailState createState() => _DoneEvaluationDetailState();
}

class _DoneEvaluationDetailState extends State<DoneEvaluationDetail> {
  DateTime _initialDate;
  DateTime _finalDate;
  TextEditingController _initialDateController = TextEditingController();
  TextEditingController _finalDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _showMessageToUser(
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
      colorTitle: greenDeepColor,
      message: customMessage,
      color: blackSoftColor,
      context: context,
      actionButtons: button,
    );
  }

  bool _isValidDate(String date) {
    try {
      DateFormat('dd/MM/yyyy').parse(date);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  bool _isFirstDateIsBeforeFinalDate() {
    _initialDate = DateFormat('dd/MM/yyyy').parse(_initialDateController.text);
    _initialDate = _initialDate.year.toString().length == 2
        ? DateTime(
            _initialDate.year + 2000, _initialDate.month, _initialDate.day)
        : _initialDate;

    print(_initialDate);

    _finalDate = DateFormat('dd/MM/yyyy').parse(_finalDateController.text);
    _finalDate = _finalDate.year.toString().length == 2
        ? DateTime(_finalDate.year + 2000, _finalDate.month, _finalDate.day)
        : _finalDate;

    print(_finalDate);

    if (_initialDate.isAfter(_finalDate)) {
      return false;
    }
    return true;
  }

  String _validateDate(String date) {
    if (date.trim().isEmpty) {
      return 'Por favor, informe uma data.';
    } else if (!_isValidDate(date.trim())) {
      return 'Por favor, informe a data no formato dd/mm/yyyy.';
    } else if (!_isFirstDateIsBeforeFinalDate()) {
      return 'A data inicial deve ser menor do que a final. Por favor, verifique!';
    }
    return null;
  }

  void _trySubmit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      widget.searchForStudentEvaluation(_initialDate, _finalDate);
    }
  }

  Future<void> _presenteDataPicker(
      BuildContext context, TextEditingController controller) async {
    try {
      final dateTime = await showDatePicker(
        context: context,
        currentDate: DateTime.now(),
        initialDate: (controller.text == null || controller.text.trim() == '')
            ? DateTime.now()
            : DateFormat('dd/MM/yyyy').parse(controller.text),
        firstDate: (controller.text == null || controller.text.trim() == '')
            ? DateTime.now().subtract(Duration(days: 366))
            : DateFormat('dd/MM/yyyy')
                .parse(controller.text)
                .subtract(Duration(days: 366)),
        lastDate: (controller.text == null || controller.text.trim() == '')
            ? DateTime.now().add(Duration(days: 366))
            : DateFormat('dd/MM/yyyy')
                .parse(controller.text)
                .add(Duration(days: 366)),
        helpText: 'Escolha a data',
        builder: (context, child) => Theme(
          data: ThemeData.light().copyWith(
            primaryColor: greenDeepColor,
            accentColor: whiteColor,
            colorScheme: ColorScheme.light(primary: greenDeepColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogTheme: Theme.of(context).dialogTheme,
          ),
          child: child,
        ),
      );

      if (dateTime == null) {
        return;
      }

      setState(() {
        controller.text = DateFormat('dd/MM/y').format(dateTime);
      });
    } on FormatException catch (_) {
      _showMessageToUser('Formato da data',
          'A data informada não está no formato correto.\n A data deve estar no formato dd/mm/yyyy.\nPor favor, verifique!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    Widget _buildDataField(DateTime dateToSave, String hintText,
        String valueKey, TextEditingController controller) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LayoutTextFields.customTextFields(
              key: ValueKey(valueKey),
              // onSaved: (date) {
              //   dateToSave = DateFormat('dd/MM/yyyy').parse(date.trim());
              // },
              controller: controller,
              onFieldSubmitted: (_) => _trySubmit(),
              validator: (date) => _validateDate(date),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: whitSoftColor,
                ),
                prefix: Padding(
                  padding: const EdgeInsets.only(left: 42.0),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _presenteDataPicker(context, controller);
                    },
                    color: whitSoftColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
            textRaisedButtonOne: 'Buscar',
            color: greenDeepColor,
            context: context,
            onPressedButtonOne: _trySubmit,
          ),
          // LayoutButtons.customFlatButtons(
          //   context: context,
          //   text: 'Cancelar',
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
    );

    final _formMessage = Text(
      'Por favor,\n informe a data',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );

    final _form = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: deviceSize.height * 0.12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _formMessage,
              _buildDataField(
                _initialDate,
                'Data de início',
                'data_inicio',
                _initialDateController,
              ),
              _buildDataField(
                _finalDate,
                'Data de término',
                'data_final',
                _finalDateController,
              ),
            ],
          ),
        ),
      ),
    );

    final _progressIndicator = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    final _content = ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: deviceSize.height * 0.83,
        maxHeight: deviceSize.height * 0.86,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _form,
          if (widget.isLoading()) _progressIndicator,
          _button,
        ],
      ),
    );

    return _content;
  }
}
