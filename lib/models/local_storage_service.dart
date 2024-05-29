import 'package:localstorage/localstorage.dart';

class LocalStorageService {

  static void setLanguageCode(String languageCode) => localStorage.setItem('language_code', languageCode);

  static String? getLanguageCode() => localStorage.getItem('language_code');

  static void setThemeIndex(int newIndex) => localStorage.setItem('theme_index', newIndex.toString());

  static int? getThemeIndex() {
    final String? themeStored = localStorage.getItem('theme_index');
    if (themeStored == null) return null;

    return int.parse(themeStored);
  }

}