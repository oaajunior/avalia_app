import 'package:flutter/material.dart';

import '../../layout/layout_page.dart';
import '../../../res/colors.dart';
import '../../../res/custom_icons.dart';
import '../../layout/layout_buttons.dart';
import '../../../view/layout/layout_text_fields.dart';
import '../../layout/layout_text_fields.dart';

class RealizarAvaliacaoBuscaView extends StatelessWidget {
  static const routeName = '/realizar_avaliacao_busca';
  final String title;

  RealizarAvaliacaoBuscaView(this.title);

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
              onPressedButtonOne: null),
        ],
      ),
    );

    final _content = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: deviceSize.height * 0.47,
          maxHeight: deviceSize.height * 0.47,
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
      color: yellowDeepColor,
      content: _content,
    );
  }
}
