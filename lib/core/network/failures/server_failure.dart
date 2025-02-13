import 'package:style_me/core/network/failures/failure.dart';

class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(super.message, this.statusCode);
}