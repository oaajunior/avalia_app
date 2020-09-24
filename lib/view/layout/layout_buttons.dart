import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LayoutButtons {
  static Widget customRaisedButtons({
    String textRaisedButtonOne,
    IconData iconRaisedButtonOne,
    Function onPressedButtonOne,
    String textRaisedButtonTwo,
    IconData iconRaisedButtonTwo,
    void Function([BuildContext ctx]) onPressedButtonTwo,
    Color color,
    BuildContext context,
    bool shortButton = false,
  }) {
    final deviceSize = MediaQuery.of(context).size;

    Widget _buildButton(
      String textButton,
      IconData iconButton,
      Function onPressedButton,
    ) {
      return Container(
        padding: shortButton
            ? const EdgeInsets.symmetric(horizontal: 0.0)
            : const EdgeInsets.symmetric(horizontal: 32.0),
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        width: shortButton ? deviceSize.width * 0.4 : deviceSize.width,
        child: Stack(
          children: [
            Container(
              width:
                  shortButton ? deviceSize.width * 0.5 : deviceSize.width * 0.9,
              height: deviceSize.height * 0.09,
              child: RaisedButton(
                color: Theme.of(context).backgroundColor,
                onPressed: onPressedButton,
                child: AutoSizeText(
                  textButton != null ? textButton : '',
                  maxLines: 1,
                  style: TextStyle(
                    color: color != null ? color : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (iconButton != null)
              Positioned(
                top: 16,
                right: 32,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: Theme.of(context).iconTheme.copyWith(
                          color: color != null ? color : Colors.white,
                          opacity: 0.3,
                        ),
                  ),
                  child: Icon(
                    iconButton,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (textRaisedButtonTwo != null)
          _buildButton(
              textRaisedButtonTwo, iconRaisedButtonTwo, onPressedButtonTwo),
        if (textRaisedButtonOne != null)
          _buildButton(
              textRaisedButtonOne, iconRaisedButtonOne, onPressedButtonOne),
      ],
    );
  }

  static Widget customFlatButtons({
    dynamic text,
    Function onPressed,
    BuildContext context,
    Color color,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: FlatButton(
        onPressed: onPressed,
        child: (text is String)
            ? DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                child: Text(
                  text,
                ),
              )
            : text,
      ),
    );
  }
}
