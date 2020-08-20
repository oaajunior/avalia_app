import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData basicTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: blueDeepColor,
    accentColor: whiteColor,
    backgroundColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,
    buttonColor: whiteColor,
    cursorColor: whiteColor,
    unselectedWidgetColor: whiteColor,
    toggleableActiveColor: whiteColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: _basicTextTheme(base.textTheme),
    buttonTheme: _basicButtonTheme(base.buttonTheme),
    iconTheme: _basicIconTheme(base.iconTheme),
    dialogTheme: _basicDialogTheme(base.dialogTheme),

    //toggleButtonsTheme: _basicToggleTheme(base.toggleButtonsTheme),
    inputDecorationTheme: _basicInputDecorationTheme(base.inputDecorationTheme),
  );
}

// ToggleButtonsThemeData _basicToggleTheme(
//     ToggleButtonsThemeData baseToggleTheme) {
//   return baseToggleTheme.copyWith(
//     color: whiteColor,
//     borderColor: whiteColor,
//     disabledBorderColor: whiteColor,
//     disabledColor: whiteColor,
//     fillColor: whiteColor,
//     selectedColor: whiteColor,
//     focusColor: whiteColor,
//     selectedBorderColor: whiteColor,
//     highlightColor: whiteColor,
//   );
// }

InputDecorationTheme _basicInputDecorationTheme(
    InputDecorationTheme baseInputDecoration) {
  return baseInputDecoration.copyWith(
    hintStyle: TextStyle(
      color: whiteColor,
      fontSize: 20,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(
        color: whiteColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(
        color: whiteColor,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: whiteColor,
      ),
      borderRadius: BorderRadius.circular(32),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(
        color: whiteColor,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(
        color: whiteColor,
      ),
    ),
    errorMaxLines: 3,
    errorStyle: TextStyle(
      color: whiteColor,
      fontSize: 18,
    ),
    //contentPadding: const EdgeInsets.fromLTRB(0.0, 16.0, 8.0, 16.0),
  );
}

DialogTheme _basicDialogTheme(DialogTheme baseDialog) {
  return baseDialog.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    backgroundColor: whiteColor,
    elevation: 1,
  );
}

ButtonThemeData _basicButtonTheme(ButtonThemeData baseButton) {
  return baseButton.copyWith(
    buttonColor: blueDeepColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    ),
    textTheme: ButtonTextTheme.normal,
  );
}

IconThemeData _basicIconTheme(IconThemeData baseIcon) {
  return baseIcon.copyWith(
    color: whiteColor,
    size: 26.0,
  );
}

TextTheme _basicTextTheme(TextTheme baseText) {
  return baseText
      .copyWith(
        bodyText1: TextStyle(
          color: whiteColor,
        ),
        bodyText2: TextStyle(
          fontSize: 20,
          color: whiteColor,
        ),
        headline2: TextStyle(
          color: whiteColor,
        ),
        headline3: TextStyle(
          color: whiteColor,
        ),
        headline4: TextStyle(
          color: whiteColor,
        ),
        headline5: TextStyle(
          color: whiteColor,
        ),
        headline6: TextStyle(
          color: whiteColor,
        ),
        subtitle1: TextStyle(
          color: whiteColor,
          fontSize: 18,
        ),
      )
      .apply(
        fontFamily: 'Quenda',
      );
}
