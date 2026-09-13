import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner_message.freezed.dart';

@freezed
sealed class BannerMessage with _$BannerMessage {
  const factory BannerMessage({
    @Default("") String message,
    @Default(true) bool isError,
    @Default(false) bool isVisible,
  }) = _BannerMessage;
}
