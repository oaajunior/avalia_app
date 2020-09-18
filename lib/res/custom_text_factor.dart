import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextFactor extends StatelessWidget {
  static double headline6ScaledSize;
  static double headline5ScaledSize;
  static double headline4ScaledSize;
  static double headline3ScaledSize;
  static double headline2ScaledSize;
  static double headline1ScaledSize;
  static double subtitle1ScaledSize;
  static double bodyText2ScaledSize;
  static double bodyText1ScaledSize;
  static double captionScaledSize;
  static double buttonScaledSize;

  @override
  Widget build(BuildContext context) {
    final _divisor = 400.0;

    final MediaQueryData _mediaQueryData = MediaQuery.of(context);

    final _screenWidth = _mediaQueryData.size.width;
    //final _factorHorizontal = _screenWidth / _divisor;

    final _screenHeight = _mediaQueryData.size.height;
    //final _factorVertical = _screenHeight / _divisor;

    //final _textScalingFactor = min(_factorVertical, _factorHorizontal);

    final _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    final _safeFactorHorizontal =
        (_screenWidth - _safeAreaHorizontal) / _divisor;

    final _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    final _safeFactorVertical = (_screenHeight - _safeAreaVertical) / _divisor;

    final _safeAreaTextScalingFactor =
        min(_safeFactorVertical, _safeFactorHorizontal);

    headline1ScaledSize = (28 * _safeAreaTextScalingFactor);
    headline2ScaledSize = (26 * _safeAreaTextScalingFactor);
    headline3ScaledSize = (24 * _safeAreaTextScalingFactor);
    headline4ScaledSize = (22 * _safeAreaTextScalingFactor);
    headline5ScaledSize = (18 * _safeAreaTextScalingFactor);
    headline6ScaledSize = (16 * _safeAreaTextScalingFactor);
    buttonScaledSize = (Theme.of(context).textTheme.button.fontSize *
        _safeAreaTextScalingFactor);
    bodyText1ScaledSize = (Theme.of(context).textTheme.bodyText1.fontSize *
        _safeAreaTextScalingFactor);
    bodyText2ScaledSize = (Theme.of(context).textTheme.bodyText2.fontSize *
        _safeAreaTextScalingFactor);
    captionScaledSize = (Theme.of(context).textTheme.caption.fontSize *
        _safeAreaTextScalingFactor);
    subtitle1ScaledSize = (Theme.of(context).textTheme.subtitle1.fontSize *
        _safeAreaTextScalingFactor);
    return this;
  }
}
