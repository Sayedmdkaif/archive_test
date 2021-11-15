import 'package:flutter/material.dart';

const Color colorPrimary = Color(0xFF00A6FF);
const Color colorSecondPrimary = Color(0xFFEBF8FF);
const Color colorPrimary2 = Color(0xFFCCDF94);
const Color colorPrimaryLight = Color(0xFF8DA64A);
const Color colorAccent = Color(0xFF96D3F5);
const Color lightAccentColor = Color(0xFFa3cdf3);
const Color textColor = Color(0xff292929);
const Color textColor2 = Color(0xff5B6978);
const Color dividerColor = Colors.white38;
const Color colorGrey = Colors.grey;
const Color lightGrey = Color(0xFFdcdcdc);
const Color whiteTransparent = Colors.white54;
const Color lightTextColor = Colors.white70;
const Color darkBlue = Color(0xFF005888);
const Color darkBlue2 = Color(0xFF00A6FF);

const Color greenColor = Color(0xFF1ABE21);
const Color color2 = Color(0xFFFF5722);
const Color red2 = Color(0xFFDD594E);
const Color colorAccent2 = Color(0xFFb1eff2);
const Color colorAccent3 = Color(0xFFEBF8FF);

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline5: base.headline5!.copyWith(color: colorPrimary));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme), primaryColor: colorPrimary);
}
