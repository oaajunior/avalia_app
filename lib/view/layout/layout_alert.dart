import 'package:flutter/material.dart';

class LayoutAlert {
  static Future<void> customAlert({
    String title,
    Widget message,
    BuildContext context,
    Color color,
    Widget actionButtons,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
          ),
          child: Container(
            width: constraints.maxWidth,
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 32.0),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              shape: DialogTheme.of(context).shape,
              backgroundColor: Theme.of(context).accentColor,
              title: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: color, fontWeight: FontWeight.bold),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
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
        ),
      ),
    );
  }
}