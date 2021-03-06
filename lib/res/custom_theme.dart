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
    unselectedWidgetColor: whiteColor,
    toggleableActiveColor: whiteColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    buttonBarTheme: _basicButtonBarTheme(base.buttonBarTheme),
    textTheme: _basicTextTheme(base.textTheme),
    buttonTheme: _basicButtonTheme(base.buttonTheme),
    iconTheme: _basicIconTheme(base.iconTheme),
    dialogTheme: _basicDialogTheme(base.dialogTheme),
    cardTheme: _basicCardTheme(base.cardTheme),
    //toggleButtonsTheme: _basicToggleTheme(base.toggleButtonsTheme),
    inputDecorationTheme: _basicInputDecorationTheme(base.inputDecorationTheme),
  );
}

ButtonBarThemeData _basicButtonBarTheme(ButtonBarThemeData basicButtonBar) {
  return basicButtonBar.copyWith(
    alignment: MainAxisAlignment.spaceEvenly,
    buttonHeight: 42.0,
    buttonMinWidth: 100.0,
    buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    mainAxisSize: MainAxisSize.min,
    layoutBehavior: ButtonBarLayoutBehavior.padded,
  );
}

InputDecorationTheme _basicInputDecorationTheme(
    InputDecorationTheme baseInputDecoration) {
  return baseInputDecoration.copyWith(
    hintStyle: TextStyle(
      color: whiteColor,
      fontSize: 18,
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
  );
}

DialogTheme _basicDialogTheme(DialogTheme baseDialog) {
  return baseDialog.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    backgroundColor: whiteColor,
    elevation: 1,
    titleTextStyle: TextStyle(
      fontSize: 24.0,
    ),
    contentTextStyle: TextStyle(
      fontSize: 18.0,
    ),
  );
}

CardTheme _basicCardTheme(CardTheme baseCard) {
  return baseCard.copyWith(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 1,
    color: whiteColor,
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
    size: 20.0,
  );
}

TextTheme _basicTextTheme(TextTheme baseText) {
  return baseText
      .copyWith(
        bodyText1: TextStyle(
          color: whiteColor,
          fontSize: 16.0,
        ),
        bodyText2: TextStyle(
          color: whiteColor,
          fontSize: 14.0,
        ),
        headline1: TextStyle(
          color: whiteColor,
          fontSize: 32,
        ),
        headline2: TextStyle(
          color: whiteColor,
          fontSize: 26,
        ),
        headline3: TextStyle(
          color: whiteColor,
          fontSize: 24,
        ),
        headline4: TextStyle(
          color: whiteColor,
          fontSize: 20,
        ),
        headline5: TextStyle(
          color: whiteColor,
          fontSize: 18,
        ),
        headline6: TextStyle(
          color: whiteColor, fontSize: 15,
          //height: 1.1,
        ),
        subtitle1: TextStyle(
          color: whiteColor,
          fontSize: 15,
        ),
      )
      .apply(
        fontFamily: 'Quenda',
      );
}
