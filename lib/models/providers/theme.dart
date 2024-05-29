import 'package:flutter/material.dart';
import 'package:thbensem_portfolio/models/local_storage_service.dart';

class AppTheme extends ChangeNotifier {

  static const List<List<Color>> themeColors = [
    [
      Color.fromARGB(255, 236, 221, 205),
      Color.fromARGB(255, 38, 38, 38),
      Color.fromARGB(255, 204, 173, 143),
      Color.fromARGB(255, 177, 132, 86),
      Colors.black,
      Colors.white
    ],
    [
      Color.fromARGB(255, 226, 226, 226),
      Color.fromARGB(255, 56, 114, 223),
      Color.fromARGB(255, 143, 200, 222),
      Color.fromARGB(255, 176, 221, 236),
      Colors.black,
      Colors.white
    ],
    [
      Color.fromARGB(255, 212, 203, 190),
      Color.fromARGB(255, 40, 40, 40),
      Color.fromARGB(255, 182, 76, 72),
      Color.fromARGB(255, 82, 83, 86),
      Colors.black,
      Colors.white
    ],
    [
      Color.fromARGB(255, 238, 238, 238),
      Color.fromARGB(255, 104, 109, 118),
      Color.fromARGB(255, 55, 58, 64),
      Color.fromARGB(255, 220, 95, 0),
      Colors.black,
      Colors.white
    ]
  ];

  int   _themeIndex = 0;

  int get         themeIndex => _themeIndex;

  List<Color> get currentTheme => themeColors[_themeIndex];

  Color get color0 => themeColors[_themeIndex][0];
  Color get color1 => themeColors[_themeIndex][1];
  Color get color2 => themeColors[_themeIndex][2];
  Color get color3 => themeColors[_themeIndex][3];

  Color get textColor0 => themeColors[_themeIndex][4];
  Color get textColor1 => themeColors[_themeIndex][5];

  void setTheme(int newIndex, {bool setInSP = true}) {
    if (setInSP) LocalStorageService.setThemeIndex(newIndex);

    _themeIndex = newIndex;
    notifyListeners();
  }
}