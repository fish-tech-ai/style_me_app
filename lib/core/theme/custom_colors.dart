import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color backgroundA85;
  final Color dangerA20;
  final Color accentA80;
  final Color googleButtonBackgroundColor;

  const CustomColors({
    required this.backgroundA85,
    required this.dangerA20,
    required this.accentA80,
    required this.googleButtonBackgroundColor,
  });

  @override
  CustomColors copyWith(
      {Color? backgroundA85,
      Color? dangerA20,
      Color? accentA80,
      Color? googleButtonBackgroundColor}) {
    return CustomColors(
      backgroundA85: backgroundA85 ?? this.backgroundA85,
      dangerA20: dangerA20 ?? this.dangerA20,
      accentA80: accentA80 ?? this.accentA80,
      googleButtonBackgroundColor:
          googleButtonBackgroundColor ?? this.googleButtonBackgroundColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      backgroundA85: Color.lerp(backgroundA85, other.backgroundA85, t)!,
      dangerA20: Color.lerp(dangerA20, other.dangerA20, t)!,
      accentA80: Color.lerp(accentA80, other.accentA80, t)!,
      googleButtonBackgroundColor: Color.lerp(
          googleButtonBackgroundColor, other.googleButtonBackgroundColor, t)!,
    );
  }
}
