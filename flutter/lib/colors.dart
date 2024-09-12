import 'package:flutter/material.dart';
import 'AppStateSingleton.dart';

class AppColors {
  // Cores base
  static const Color _darkPurple = Color(0xFF5E17EB);
  static const Color _lightPurple = Color(0xFF8C52FF);
  static const Color _black = Color(0xFF0E0E0E);
  static const Color _white = Color(0xFFE6E6E6);
  static const Color _lightBlackForFooter = Color(0xFF18141C);

  static Color get darkPurple => _getColorForTheme(_darkPurple, _darkPurple);
  static Color get lightPurple => _getColorForTheme(_lightPurple, _lightPurple);
  static Color get black => _getColorForTheme(_black, _white);
  static Color get white => _getColorForTheme(_white, _black);
  static Color get lightBlackForFooter => _getColorForTheme(_lightBlackForFooter, Color.fromARGB(255, 246, 237, 255));

  static Color _getColorForTheme(Color darkModeColor, Color lightModeColor) {
    return AppStateSingleton().themeModeNotifier.value == ThemeMode.dark ? darkModeColor : lightModeColor;
  }
}
