import 'package:style_me/core/network/exceptions/helpers/image_error_type/image_type_enum.dart';
import 'package:style_me/core/network/failures/failure.dart';

class ImageProcessFailure extends Failure {
  final ImageErrorTypeEnum type;

  ImageProcessFailure(super.message, this.type);
}