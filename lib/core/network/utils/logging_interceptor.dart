import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class LoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final request = chain.request;

    log('======================================> REQUEST <======================================');
    log('Method: ${request.method}');
    log('URL: ${request.url}');
    log('Headers: ${request.headers}');
    if (request.body != null) {
      log('Body: ${request.body}');
    }

    final response = await chain.proceed(request);

    log('======================================> RESPONSE <======================================');
    log('Status Code: ${response.statusCode}');
    log('URL: ${response.base.request?.url}');
    log('Headers: ${response.headers}');
    log('Body: ${response.body}');
    log('========================================================================================');

    return response;
  }

  void log(String message) {
    debugMessagePrint("\x1B[90m[NETWORKING]\x1B[0m \x1B[36m$message\x1B[0m");
  }
}
