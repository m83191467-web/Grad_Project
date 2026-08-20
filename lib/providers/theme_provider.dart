import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode get themeMode => ThemeMode.light;
  bool get isDarkMode => false;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> toggleDarkMode(bool enabled) async {
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', false);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool('dark_mode');
    if (savedValue != null && savedValue) {
      await prefs.setBool('dark_mode', false);
    }
  }
}
