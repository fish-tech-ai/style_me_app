import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:style_me/core/app/domain/usecases/get_user_use_case.dart';
import 'package:style_me/core/di/get_it.dart';
import 'package:style_me/core/extensions/global_ext.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/utils/constants.dart';

class AppHeadersInterceptor implements Interceptor {
  const AppHeadersInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final result = await getIt<GetUserUseCase>().call();
    String? token;
    result.collect(
      (user) => token = user.token,
      (Failure failure) => debugMessagePrint(failure.toString()),
    );
    final headers = {NetworkHeaders.apiKey: dotenv.env['API_KEY'] ?? ''};
    if (token != null) {
      headers.putIfAbsent(NetworkHeaders.authorization, () => 'Bearer $token');
    }
    return chain.proceed(
      applyHeaders(
        chain.request,
        headers,
      ),
    );
  }
}
