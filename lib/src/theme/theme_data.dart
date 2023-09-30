import 'package:flutter/material.dart';

class CustomThemeData {
  final double defaultPadding = 20.0;
  final double smallPadding = 10.0;
  final double largePadding = 30.0;

  final Color textColor;
  final Color themeColor;
  final LinearGradient splashGradient;
  final LinearGradient bgGradient;
  final LinearGradient onboardingButtonGradient;
  final Color bgColor;
  final Color appBarColor;
  final Color linkColor;
  final Color bgThemeColor;
  final Color btnColor;
  final Color pillColor;
  final Color searchAppBarColor;
  final Color chatContainerColor;
  final Color textDarkLightColor;
  final Color whiteColor;
  final Color textDarkColor;
  final Color chatBadgeColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color textFieldTitleColor;
  final TextStyle textStyle;
  final Color grayTextColor;
  final Color teal;
  final LinearGradient tipsGradient;
  final LinearGradient fabGradient;
  final Color grayLightTextColor;
  final Color dropDownColor;

  CustomThemeData({
    this.textColor = const Color(0xFF775CB8),
    required this.bgColor,
    required this.themeColor,
    required this.textStyle,
    required this.appBarColor,
    required this.splashGradient,
    required this.bgGradient,
    required this.onboardingButtonGradient,
    required this.linkColor,
    required this.bgThemeColor,
    required this.btnColor,
    required this.pillColor,
    required this.searchAppBarColor,
    required this.chatContainerColor,
    required this.textDarkLightColor,
    required this.textDarkColor,
    required this.whiteColor,
    required this.chatBadgeColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.textFieldTitleColor,
    required this.grayTextColor,
    required this.teal,
    required this.tipsGradient,
    required this.fabGradient,
    required this.grayLightTextColor,
    required this.dropDownColor,
  });
}

final _customLightTheme = CustomThemeData(
  textColor: Colors.black,
  bgColor: const Color(0xffFFFFFF),
  themeColor: const Color.fromRGBO(99, 106, 177, 1),
  textStyle: const TextStyle(color: Colors.black),
  splashGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(99, 106, 177, 1),
      Color.fromRGBO(124, 131, 200, 1),
    ],
  ),
  bgGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEDEEF8),
      Color(0xFFFFFFFF),
    ],
  ),
  onboardingButtonGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(219, 221, 238, 1),
    ],
  ),
  tipsGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xFF080D3E),
    ],
  ),
  fabGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFE3E3E3),
    ],
  ),
  appBarColor: Colors.white,
  linkColor: Colors.blue,
  bgThemeColor: Colors.white,
  btnColor: const Color(0xFF9BECF6),
  pillColor: const Color(0xFFE5F5F7),
  searchAppBarColor: const Color(0xFF9497F3),
  chatContainerColor: const Color(0xff5CCEBD),
  textDarkLightColor: const Color(0xffEBEBEB),
  textDarkColor: const Color(0xff5E5C5D),
  whiteColor: Colors.white,
  chatBadgeColor: const Color(0xff5CCEBD),
  primaryColor: const Color(0xff636AB1),
  secondaryColor: const Color(0xff95CEFF),
  textFieldTitleColor: const Color(0xff9FA5C0),
  grayTextColor: const Color(0xff7E7E7E),
  grayLightTextColor: const Color(0xffF3F3F3),
  teal: const Color(0xFF4FB9B3),
  dropDownColor: const Color(0xffF2F2F2),
);

final _customDarkTheme = CustomThemeData(
  textColor: Colors.white,
  bgColor: const Color(0xffF8F9FD),
  themeColor: const Color.fromRGBO(99, 106, 177, 1),
  textStyle: const TextStyle(color: Colors.white),
  splashGradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(99, 106, 177, 1),
      Color.fromRGBO(124, 131, 200, 1),
    ],
  ),
  bgGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEDEEF8),
      Color(0xFFFFFFFF),
    ],
  ),
  onboardingButtonGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromRGBO(219, 221, 238, 1),
    ],
  ),
  tipsGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white,
      Color(0xFF080D3E),
    ],
  ),
  fabGradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFE3E3E3),
    ],
  ),
  appBarColor: const Color(0xff2F282A),
  linkColor: Colors.blue,
  bgThemeColor: Colors.black,
  btnColor: const Color(0xFF9BECF6),
  pillColor: const Color(0xFFE5F5F7),
  searchAppBarColor: const Color(0xFFA8AAEF),
  chatContainerColor: const Color(0xFF1C1A1B),
  chatBadgeColor: const Color(0xff5CCEBD),
  textDarkLightColor: const Color(0xffEBEBEB),
  textDarkColor: const Color(0xff5E5C5D),
  whiteColor: Colors.black,
  primaryColor: const Color(0xff1D3A70),
  secondaryColor: const Color(0xff95CEFF),
  textFieldTitleColor: const Color(0xff9FA5C0),
  grayTextColor: const Color(0xff7E7E7E),
  teal: const Color(0xFF4FB9B3),
  grayLightTextColor: const Color(0xffF3F3F3),
  dropDownColor: const Color(0xffF2F2F2),
);

extension CustomTheme on ThemeData {
  CustomThemeData get custom =>
      brightness == Brightness.light ? _customLightTheme : _customDarkTheme;
}
