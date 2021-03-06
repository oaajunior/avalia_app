import 'package:flutter/material.dart';

class LayoutAlert {
  static Future<void> customAlert({
    String title,
    Widget message,
    BuildContext context,
    Color colorTitle,
    Color color,
    Widget actionButtons,
    bool barrierDismissible = true,
    bool countTimer = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => LayoutBuilder(builder: (context, constraints) {
        if (countTimer) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
        }
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
          ),
          child: Container(
            width: constraints.maxWidth * 0.85,
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 40.0),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              shape: DialogTheme.of(context).shape,
              backgroundColor: Theme.of(context).accentColor,
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: colorTitle != null ? colorTitle : color,
                      fontWeight: FontWeight.bold,
                    ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: color,
                      ),
                  child: message,
                ),
              ),
              actions: [
                actionButtons,
              ],
            ),
          ),
        );
      }),
    );
  }
}
