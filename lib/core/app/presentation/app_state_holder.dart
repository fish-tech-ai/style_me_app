import 'package:flutter/material.dart';

class AppStateHolder {
  final Brightness? currentTheme;

  AppStateHolder({this.currentTheme});

  AppStateHolder copyWith(Brightness? currentTheme) {
    return AppStateHolder(currentTheme: currentTheme ?? this.currentTheme);
  }
}
