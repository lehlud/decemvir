import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

ThemeData _theme(ThemeData base) {
  return base.copyWith(
    cardTheme: base.cardTheme.copyWith(
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),
  );
}

ThemeData get lightTheme => _theme(yaruLight);
ThemeData get darkTheme => _theme(yaruDark);
