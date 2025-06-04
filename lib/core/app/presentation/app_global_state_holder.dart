import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/core/app/presentation/ui_models/banner_message.dart';
import 'package:style_me/core/app/presentation/ui_models/bottom_bar_state.dart';

part 'app_global_state_holder.freezed.dart';

@freezed
class AppGlobalStateHolder with _$AppGlobalStateHolder {
  const factory AppGlobalStateHolder({
    Brightness? currentTheme,
    Locale? lang,
    @Default(true) bool isConnected,
    @Default(BannerMessage()) BannerMessage bannerMessage,
    @Default(BottomBarState()) BottomBarState bottomBarState,
    @Default(false) isOnboardingRunning,
    @Default(false) isUserMakingOnboardingActions,
    @Default(false) isOnboardingExitDialogVisible,
    @Default(0) int onboardingStep
  }) = _AppStateHolder;
}
