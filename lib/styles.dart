import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const headlineText = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontFamily: 'NotoSans',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const primaryText = TextStyle(fontSize: 20.0, color: Colors.white);
  static const primaryCardText = TextStyle(fontSize: 20.0, color: Colors.black);
  static const secondaryText = TextStyle(fontSize: 18.0, color: Colors.white);
  static const secondaryTextLogin = TextStyle(fontSize: 18.0, color: Colors.black);

  static const errorText = TextStyle(
      fontSize: 13.0,
      color: Colors.red,
      height: 1.0,
      fontWeight: FontWeight.w300);

  static const homeListPadding = EdgeInsets.all(10);
  static const inputFormPadding = EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0);
  static const primaryButtonPadding = EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0);
  static const cardPadding = EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0);
  static const cardHeadPadding = EdgeInsets.only(bottom: 8.0);
  static const appBackground = Color(0xffd0d0d0);

  static const preferenceIcon = IconData(
    0xf443,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const servingInfoBorderColor = Color(0xffb0b0b0);

  static const ColorFilter desaturatedColorFilter =
      // 222222 is a random color that has low color saturation.
      ColorFilter.mode(Color(0xFF222222), BlendMode.saturation);
}
