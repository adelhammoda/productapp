import 'package:flutter/material.dart';
import 'package:product_app/models/theme.dart';

//all themes in app
final List<MyTheme> themes = [
  MyTheme('1',
      cardColor: const Color(0xFFFFFFFF),
      cursorColor: const Color(0xffc9bae2),
      focusColor: const Color(0xff1f1235),
      textColor: const Color(0xffc9bae2),
      iconColor: const Color(0xffff6e6c),
      backGroundColor: const Color(0xffFFFFFF),
      accentColor: const Color(0xffcabae2),
      canvasColor: const Color(0xff463366),
      appBarColor: const Color(0xff67568c),
      secondaryColor: const Color(0xfffbdd74),
      isLight: false,
      primaryColor: _createMaterialColor(const Color(0xffc9bae2))),
];
//
MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
