import 'package:flutter/material.dart';

import '../../res/custom_icons_button.dart';

class LayoutPage {
  static void _backPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void _backToBegin(BuildContext context, int pageToBack) {
    switch (pageToBack) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pop();
        break;
      case 2:
        Navigator.of(context)..pop()..pop();
        break;
      case 3:
        Navigator.of(context)..pop()..pop()..pop();
        break;
      default:
        Navigator.of(context).pop();
        break;
    }
    //Navigator.of(context).popUntil(ModalRoute.withName(HomeView.routeName));
  }

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
      width: deviceSize.width,
      child: Row(
        mainAxisAlignment: hasHeaderButtons
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          if (hasHeaderButtons)
            Padding(
              padding: const EdgeInsets.only(right: 48),
              child: IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                icon: Icon(
                  CustomIconsButton.button_back,
                ),
                onPressed: () => _backPage(context),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Text(
              headerTitle != null ? headerTitle : '',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          if (hasHeaderButtons)
            Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: IconButton(
                iconSize: Theme.of(context).iconTheme.size,
                icon: Icon(CustomIconsButton.button_home),
                onPressed: () => _backToBegin(context, numberPagesToHome),
              ),
            ),
        ],
      ),
    );

    final _mainText = Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        mainText != null ? mainText : '',
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
                    _buildSizedBox(24),
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
