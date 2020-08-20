import 'package:avalia_app/view/layout/layout_text_fields.dart';
import 'package:flutter/material.dart';

import '../layout/layout_page.dart';
import '../../res/colors.dart';
import '../../res/custom_icons.dart';
import '../../view/layout/layout_buttons.dart';

class RealizarAvaliacaoScreen extends StatelessWidget {
  static const routeName = '/realizar_avaliacao';
  final String title;

  RealizarAvaliacaoScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final _textField = LayoutTextFields.customTextFields(
      decoration: InputDecoration(hintText: 'Código'),
      keyboardType: TextInputType.visiblePassword,
      textStyle: Theme.of(context).textTheme.headline6,
    );

    final _button = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LayoutButtons.customRaisedButtons(
              textRaisedButtonOne: 'Buscar',
              iconRaisedButtonOne: CustomIcons.icon_search_evaluation,
              color: yellowDeepColor,
              context: context,
              onPressedButtonOne: () {}),
        ],
      ),
    );

    final _content = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: deviceSize.height * 0.45,
          maxHeight: deviceSize.height * 0.45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _textField,
            _button,
          ],
        ));
    return LayoutPage.render(
      hasHeader: true,
      hasHeaderButtons: true,
      headerTitle: 'avalia',
      context: context,
      mainText: title,
      message: 'Por favor,\n informe o código',
      color: yellowDeepColor,
      content: _content,
    );
  }
}
