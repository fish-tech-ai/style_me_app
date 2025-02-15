import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:style_me/features/settings/presentation/ui_models/setting.dart';

part 'settings_state_holder.freezed.dart';

@freezed
class SettingsStateHolder with _$SettingsStateHolder {
  const factory SettingsStateHolder({
    @Default([]) List<Setting> appSettings,
    @Default([]) List<Setting> accountSettings,
    @Default(true) bool isLoading,
    @Default("") String userEmail
  }) = _SettingsStateHolder;
}
