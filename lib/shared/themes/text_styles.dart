import 'package:flutter/material.dart';
import 'package:abodesv1/shared/constants/dimens.dart';

class TextStyles {
  static const String _fontFamily = 'M PLUS 1p';

  static TextStyle welcomeTitle = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.titleFontSize,
    height: Dimens.titleLineHeight,
    color: Colors.white,
  );

  static TextStyle welcomeDescription = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.bodyFontSize,
    height: Dimens.bodyLineHeight,
    color: Colors.white,
  );

  static TextStyle buttonText = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.buttonFontSize,
    color: Colors.black,
  );
}
