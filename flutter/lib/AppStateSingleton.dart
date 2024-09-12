import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateSingleton {
  static final AppStateSingleton _instance = AppStateSingleton._internal();
  factory AppStateSingleton() => _instance;
  AppStateSingleton._internal();

  String ApiUrl = '';
  ValueNotifier<String> userProfileImageUrlNotifier = ValueNotifier<String>('');
  String userName = '';
  List<String> collections = [];
  String statisticsJson = '';

  static bool isDarkMode = false;
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    themeModeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> saveThemeMode(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
    isDarkMode = isDark;
    themeModeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
