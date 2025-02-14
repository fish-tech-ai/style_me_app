import 'dart:io';

import 'package:style_me/core/network/failures/failure.dart';

class LoginFailure extends Failure {
  LoginFailure(super.message);
  
  factory LoginFailure.from(Failure failure, String loginFailedMessage) {
    return LoginFailure(
        failure.message == HttpStatus.unauthorized.toString()
            ? loginFailedMessage
            : failure.message);
  }
}