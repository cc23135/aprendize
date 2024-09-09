// lib/AppStateSingleton.dart
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
  String statisticsJson = ''; // Adicione esta linha para armazenar o JSON

  static const String _keyThemeMode = 'theme_mode';
  ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, themeMode.toString());
    themeModeNotifier.value = themeMode;
  }

  Future<void> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_keyThemeMode);
    switch (themeModeString) {
      case 'ThemeMode.dark':
        themeModeNotifier.value = ThemeMode.dark;
        break;
      case 'ThemeMode.light':
        themeModeNotifier.value = ThemeMode.light;
        break;
      default:
        themeModeNotifier.value = ThemeMode.system;
    }
  }
}