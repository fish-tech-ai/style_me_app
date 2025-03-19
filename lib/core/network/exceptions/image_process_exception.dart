import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';

class ImageProcessException implements Exception {
  final ImageErrorTypeEnum type;

  ImageProcessException(this.type);
}
