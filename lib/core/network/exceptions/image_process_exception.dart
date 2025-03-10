import 'package:style_me/core/network/exceptions/helpers/error_type_enum.dart';

class ImageProcessException implements Exception {
  final ErrorTypeEnum type;

  ImageProcessException(this.type);
}
