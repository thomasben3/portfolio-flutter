import 'package:flutter/material.dart';
import 'package:thbensem_portfolio/models/local_storage_service.dart';


class L10n extends ChangeNotifier {
  static const locales = [
    Locale('en'),
    Locale('fr'),
  ];

  Locale _current = const Locale('en');

  Locale get currentLocale => _current;

  void setLocale(String languageCode, {bool setInSP = true}) {
    if (setInSP) {
      LocalStorageService.setLanguageCode(languageCode);
    }

    _current = Locale(languageCode);
    notifyListeners();
  }
}