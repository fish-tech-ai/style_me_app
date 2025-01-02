import 'package:flutter/material.dart';

mixin AppColorsMixin {
  Color get accent;
  Color get accentA20;
  Color get accentA80;
  Color get textOnAccent;
  Color get background;
  Color get backgroundA85;
  Color get backgroundDarker;
  Color get disabled;
  Color get danger;
  Color get dangerA20;
  Color get text;
  Color get textDisabled;
  Color get surface;
  Color get surfaceA90;
  Color get textSecondary;
  Color get dangerSurface;
}

class AppColorsDark with AppColorsMixin {
  @override
  Color get accent => const Color(0xFF7B4DB2);
  @override
  Color get accentA20 => const Color(0x337B4DB2);
  @override
  Color get accentA80 => const Color(0xCC7B4DB2);
  @override
  Color get textOnAccent => const Color(0xFFF1E5FF);
  @override
  Color get background => const Color(0xFF0F0D12);
  @override
  Color get backgroundA85 => const Color(0xD90F0D12);
  @override
  Color get backgroundDarker => const Color(0xFF0A090C);
  @override
  Color get disabled => const Color(0xFF262427);
  @override
  Color get danger => const Color(0xFF934242);
  @override
  Color get dangerA20 => const Color(0x33934242);
  @override
  Color get text => const Color(0xFFF1E5FF);
  @override
  Color get textDisabled => const Color(0xFF6C686F);
  @override
  Color get surface => const Color(0xFF251934);
  @override
  Color get surfaceA90 => const Color(0xE6251934);
  @override
  Color get textSecondary => const Color(0xFFC5C5C5);
  @override
  Color get dangerSurface => const Color(0xFF2B181C);
}

class AppColorsLight with AppColorsMixin {
  @override
  Color get accent => const Color(0xFF8B6AB1);
  @override
  Color get accentA20 => const Color(0x338B6AB1);
  @override
  Color get accentA80 => const Color(0xCC8B6AB1);
  @override
  Color get textOnAccent => const Color(0xFFF1E4FF);
  @override
  Color get background => const Color(0xFFF7F1FF);
  @override
  Color get backgroundA85 => const Color(0xD9F7F1FF);
  @override
  Color get backgroundDarker => const Color(0xFFFBF9FF);
  @override
  Color get disabled => const Color(0xFFC2BCCA);
  @override
  Color get danger => const Color(0xFF934242);
  @override
  Color get dangerA20 => const Color(0x33934242);
  @override
  Color get text => const Color(0xFF46345A);
  @override
  Color get textDisabled => const Color(0xFF6C686F);
  @override
  Color get surface => const Color(0xFFDED0F0);
  @override
  Color get surfaceA90 => const Color(0xE6DED0F0);
  @override
  Color get textSecondary => const Color(0xFF777777);
  @override
  Color get dangerSurface => const Color(0xFF2B181C);
}

