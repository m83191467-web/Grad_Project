import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguageProvider extends ChangeNotifier {

  Locale _locale = const Locale('ar');


  Locale get locale => _locale;



  LanguageProvider() {

    loadLanguage();

  }



  Future<void> changeLanguage(String languageCode) async {

    _locale = Locale(languageCode);


    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'language',
      languageCode,
    );


    notifyListeners();

  }




  Future<void> loadLanguage() async {

    final prefs = await SharedPreferences.getInstance();


    String? savedLanguage =
    prefs.getString('language');



    if (savedLanguage != null) {

      _locale = Locale(savedLanguage);

      notifyListeners();

    }

  }

}