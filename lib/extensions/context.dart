import 'package:flutter/material.dart';

extension EContext on BuildContext {
  bool get isTouchDevice {
    final platform = Theme.of(this).platform;
    
    return platform == TargetPlatform.android ||
      platform == TargetPlatform.iOS ||
      platform == TargetPlatform.fuchsia;
  }
}