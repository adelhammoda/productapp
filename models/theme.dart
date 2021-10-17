import 'package:flutter/material.dart';

class MyTheme {
  MaterialColor? primaryColor;
  final String name;
  final Color cursorColor,
      textColor,
      iconColor,
      backGroundColor,
      accentColor,
      canvasColor,
      appBarColor,
      secondaryColor,
      focusColor,
      cardColor;
  bool isLight;

  MyTheme(this.name,
      {required this.cursorColor,
      required this.focusColor,
      required this.textColor,
      required this.iconColor,
      required this.backGroundColor,
      required this.accentColor,
      required this.canvasColor,
      required this.appBarColor,
      required this.secondaryColor,
      required this.isLight,
      required this.primaryColor,
      required this.cardColor});

  bool isEqualTo(MyTheme theme) {
    if (theme.isLight == isLight &&
        theme.isLight == isLight &&
        theme.textColor == textColor &&
        theme.iconColor == iconColor &&
        theme.backGroundColor == backGroundColor &&
        theme.accentColor == accentColor &&
        theme.canvasColor == canvasColor &&
        theme.appBarColor == appBarColor &&
        theme.secondaryColor == secondaryColor &&
        theme.primaryColor == primaryColor &&
        theme.focusColor == focusColor) {
      return true;
    } else {
      return false;
    }
  }
}
