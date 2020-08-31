import 'package:auto_size_text/auto_size_text.dart';
import 'package:avalia_app/res/custom_icon.dart';
import 'package:flutter/material.dart';

import '../../res/custom_icon_button.dart';

class LayoutPage {
  static void _backPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  // static void _backToBegin(BuildContext context) {
  //   Navigator.of(context)
  //       .popUntil(ModalRoute.withName(PerformEvaluationView.routeName));
  // }

  static Widget render({
    bool hasHeader = false,
    bool hasHeaderButtons = false,
    String headerTitle,
    String mainText,
    String message,
    Color color,
    BuildContext context,
    int numberPagesToHome,
    Widget content,
  }) {
    final deviceSize = MediaQuery.of(context).size;

    final _header = Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      padding: const EdgeInsets.only(top: 8),
      width: deviceSize.width,
      child: Stack(
        alignment: hasHeaderButtons ? Alignment.topLeft : Alignment.topCenter,
        children: [
          if (hasHeaderButtons)
            IconButton(
              iconSize: Theme.of(context).iconTheme.size,
              icon: Icon(
                CustomIconButton.button_back,
              ),
              onPressed: () => _backPage(context),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
                child: Icon(
              CustomIcon.icon_logo_avalia,
              size: 70,
            )
                // Text(
                //   headerTitle != null ? headerTitle : '',
                //   style: Theme.of(context).textTheme.headline3,
                // ),
                ),
          ),
        ],
      ),
      // if (hasHeaderButtons)
      //   Padding(
      //     padding: const EdgeInsets.only(right: 48.0),
      //     child: IconButton(
      //       iconSize: Theme.of(context).iconTheme.size,
      //       icon: Icon(CustomIconButton.button_home),
      //       onPressed: () => _backToBegin(context),
      //     ),
      //   ),
    );

    final _mainText = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AutoSizeText(
        mainText != null ? mainText : '',
        wrapWords: false,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
    );

    final _message = Text(
      message != null ? message : '',
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );

    Widget _buildSizedBox(double value) {
      return SizedBox(
        height: value,
      );
    }

    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: deviceSize.height * 0.95,
            ),
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasHeader) _header,
                    if (mainText != null) _mainText,
                    _buildSizedBox(8),
                    if (message != null) _message,
                    _buildSizedBox(8),
                  ],
                ),
                if (content != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: deviceSize.height * 0.45,
                      maxHeight: deviceSize.height * 1.25,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        content,
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
