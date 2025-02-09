import 'package:chopper/chopper.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';

extension ResponseErrorHandling<T> on Response<T> {
  void handleIfNotSuccessful() {
    if (!isSuccessful) {
      String errorMessage = error.toString();
      throw ServerException(
          "$statusCode: ${errorMessage.isEmpty ? "Unknown reason" : errorMessage}");
    }
  }
}
