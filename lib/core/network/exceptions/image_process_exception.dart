import 'package:style_me/core/network/exceptions/helpers/error_type_enum.dart';

class ImageProcessException implements Exception {
  final ImageErrorTypeEnum type;

  ImageProcessException(this.type);
}
