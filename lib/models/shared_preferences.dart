import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  static Future<void> setLanguageCode(String languageCode) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('language_code', languageCode);
  }

  static Future<String?> getLanguageCode() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getString('language_code');
  }

  static Future<void> setThemeIndex(int newIndex) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    
    await sp.setInt('theme_index', newIndex);
  }

  static Future<int?> getThemeIndex() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    return sp.getInt('theme_index');
  }

}