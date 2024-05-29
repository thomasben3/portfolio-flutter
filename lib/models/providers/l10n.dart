import 'package:flutter/material.dart';
import 'package:thbensem_portfolio/models/shared_preferences.dart';


class L10n extends ChangeNotifier {
  static const locales = [
    Locale('en'),
    Locale('fr'),
  ];

  Locale _current = const Locale('en');

  Locale get currentLocale => _current;

  Future<void> setLocale(String languageCode, {bool setInSP = true}) async {
    if (setInSP) {
      await SharedPreferencesManager.setLanguageCode(languageCode);
    }

    _current = Locale(languageCode);
    notifyListeners();
  }
}