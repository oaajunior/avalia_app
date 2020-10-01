import 'package:auto_size_text/auto_size_text.dart';
import 'package:avalia_app/res/custom_icon.dart';
import 'package:flutter/material.dart';

import '../../res/colors.dart';
import '../../res/custom_button_icon.dart';

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
    bool hasHeaderLogo = false,
    bool hasFirstButton = false,
    bool hasSecondButton = false,
    bool firstButtonIconClose = false,
    Function onPressedButtonOne,
    Function onPressedButtonSecond,
    String headerTitle,
    String mainText,
    String message,
    Color color,
    BuildContext context,
    Widget content,
    ScrollController scrollController,
  }) {
    final deviceSize = MediaQuery.of(context).size;

    final _header = Container(
      margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      width: deviceSize.width,
      height: !hasHeaderLogo ? deviceSize.height * 0.08 : null,
      child: Row(
        mainAxisAlignment: !hasHeaderLogo
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (hasFirstButton)
            IconButton(
              iconSize: firstButtonIconClose ? 30 : 22,
              icon: Icon(
                firstButtonIconClose
                    ? Icons.close_rounded
                    : CustomButtonIcon.button_back_without_desc,
                color: whiteColor,
              ),
              onPressed: () => onPressedButtonOne != null
                  ? onPressedButtonOne
                  : _backPage(context),
            ),
          if (headerTitle != null)
            Container(
              alignment: Alignment.center,
              width: deviceSize.width * 0.65,
              child: AutoSizeText(
                headerTitle,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          if (hasHeaderLogo)
            Container(
              height: deviceSize.height * 0.28,
              padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
              child: Center(
                  child: Image.asset(
                'lib/res/images/avalia_logo.png',
              )),
            ),
          if (hasSecondButton)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                iconSize: 35,
                icon: Icon(
                  CustomIcon.icon_ranking,
                  color: whiteColor,
                ),
                onPressed: () => onPressedButtonSecond(),
              ),
            ),
          if (!hasSecondButton && !hasHeaderLogo)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              width: deviceSize.width * 0.1,
            )
        ],
      ),
    );

    final _mainText = Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: AutoSizeText(
          mainText != null ? mainText : '',
          wrapWords: false,
          style: Theme.of(context).textTheme.headline2,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final _message = Flexible(
      child: Text(
        message != null ? message : '',
        style: Theme.of(context).textTheme.headline4,
        textAlign: TextAlign.center,
      ),
    );

    Widget _buildSizedBox(double value) {
      return SizedBox(
        height: value,
      );
    }

    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasHeader) _header,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (mainText != null) _mainText,
                  if (mainText != null) _buildSizedBox(8),
                  if (message != null) _message,
                  if (message != null) _buildSizedBox(8),
                  if (content != null)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: deviceSize.height * 0.45,
                        maxHeight: deviceSize.height * 1.6,
                      ),
                      child: content,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
