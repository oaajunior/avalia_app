import 'package:flutter/material.dart';

import '../../../layout/layout_buttons.dart';
import '../../../layout/layout_text_fields.dart';
import '../../../../res/colors.dart';

class PerformEvaluationDetailView extends StatefulWidget {
  final Function isLoading;
  final Function searchForEvaluationCode;
  PerformEvaluationDetailView(this.isLoading, this.searchForEvaluationCode);
  @override
  _PerformEvaluationDetailViewState createState() =>
      _PerformEvaluationDetailViewState();
}

class _PerformEvaluationDetailViewState
    extends State<PerformEvaluationDetailView> {
  String _codigoAvaliacao;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    String _validateCodigo(String value) {
      if (value.trim().isEmpty) {
        return 'Por favor, informe o código.';
      } else {
        if (value.length < 4) {
          return 'O código possui mais de 4 caracteres. Por favor, verifique!';
        }
      }
      return null;
    }

    void _trySubmit() {
      final _isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (_isValid) {
        _formKey.currentState.save();
        widget.searchForEvaluationCode(_codigoAvaliacao);
      }
    }

    final _textField = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Por favor,\n informe um código',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          LayoutTextFields.customTextFields(
            decoration: InputDecoration(
              hintText: 'Código',
              hintStyle: TextStyle(
                color: whitSoftColor,
              ),
            ),
            key: ValueKey('codigo'),
            onSaved: (codigo) {
              _codigoAvaliacao = codigo.trim();
            },
            onFieldSubmitted: (_) => _trySubmit(),
            validator: (codigo) => _validateCodigo(codigo),
          ),
        ],
      ),
    );

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
            textRaisedButtonOne: 'Buscar',
            color: yellowDeepColor,
            context: context,
            onPressedButtonOne: _trySubmit,
          ),
        ],
      ),
    );

    final _form = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: deviceSize.height * 0.2),
        child: Center(
          child: _textField,
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
