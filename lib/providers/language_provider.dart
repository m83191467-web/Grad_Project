import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  LanguageProvider() {
    loadLanguage();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') return;
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language');
    if (savedLanguage != 'ar' && savedLanguage != 'en') return;
    if (_locale.languageCode == savedLanguage) return;

    _locale = Locale(savedLanguage!);
    notifyListeners();
  }
}
