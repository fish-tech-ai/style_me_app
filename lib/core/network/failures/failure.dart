import 'package:style_me/core/network/failures/server_failure.dart';

abstract class Failure {
  final String? message;

  Failure(this.message);

  @override
  String toString() {
    return message ?? super.toString();
  }

  bool isStatusCodeEquals(int statusCode) {
    return this is ServerFailure &&
        (this as ServerFailure).statusCode == statusCode;
  }
}
