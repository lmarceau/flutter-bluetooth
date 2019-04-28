import 'package:flutter/material.dart';

final ThemeData hxThemeData = new ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.light,
    accentColor: HxColors.hxBlue[500],
    accentColorBrightness: Brightness.light
);

class HxColors {
  HxColors._();

  static const _hxPrimaryValue = 0xFF088CCC;

  static const MaterialColor hxBlue = const MaterialColor(
    _hxPrimaryValue,
    const <int, Color>{
      50:  const Color(0xFFE7f6FE),
      100: const Color(0xFFB6E4FC),
      200: const Color(0xFF85D3FA),
      300: const Color(0xFF54C1F8),
      400: const Color(0xFF23AFF6),
      500: const Color(_hxPrimaryValue),
      600: const Color(0xFF23AFF6),
      700: const Color(0xFF0775AB),
      800: const Color(0xFF05537A),
      900: const Color(0xFF033249),
    },
  );
}