import 'package:style_me/core/network/exceptions/helpers/error_type_enum.dart';
import 'package:style_me/core/network/failures/failure.dart';

class ImageProcessFailure extends Failure {
  final ErrorTypeEnum type;

  ImageProcessFailure(super.message, this.type);
}