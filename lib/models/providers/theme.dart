import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  Color _color0 = const Color.fromARGB(255, 226, 226, 226);
  Color _color1 = const Color.fromARGB(255, 56, 114, 223);
  Color _color2 = Color.fromARGB(255, 143, 200, 222);
  Color _color3 = const Color.fromARGB(255, 214, 232, 227);
  Color _color4 = const Color.fromARGB(255, 0, 72, 207);

  Color _textColor0 = Colors.black;
  Color _textColor1 = Colors.white;

  Color get color0 => _color0;
  Color get color1 => _color1;
  Color get color2 => _color2;
  Color get color3 => _color3;
  Color get color4 => _color4;

  Color get textColor0 => _textColor0;
  Color get textColor1 => _textColor1;

  void setTheme0() {
    _color0 = const Color.fromARGB(255, 226, 226, 226);
    _color1 = const Color.fromARGB(255, 56, 114, 223);
    _color2 = const Color.fromARGB(255, 177, 213, 227);
    _color3 = const Color.fromARGB(255, 214, 232, 227);
    _color4 = const Color.fromARGB(255, 0, 72, 207);

    _textColor0 = Colors.black;
    _textColor1 = Colors.white;
  }
}