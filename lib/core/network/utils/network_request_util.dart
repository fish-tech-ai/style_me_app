import 'package:style_me/core/network/exceptions/image_process_exception.dart';
import 'package:style_me/core/network/exceptions/server_exception.dart';
import 'package:style_me/core/network/failures/failure.dart';
import 'package:style_me/core/network/failures/image_process_failure.dart';
import 'package:style_me/core/network/failures/server_failure.dart';
import 'package:style_me/core/network/failures/unknown_failure.dart';
import 'package:style_me/core/network/utils/result.dart';

class NetworkRequestUtil {
  Future<Result<T>> makeRepositoryRequest<T>(
    Future<T> Function() request, {
    Future Function(T result)? onSuccess,
    Future Function(Failure failure)? onError,
  }) async {
    try {
      final response = await request();
      if (onSuccess != null) {
        onSuccess(response);
      }
      return Result.success(response);
    } on ServerException catch (error) {
      final failure = ServerFailure(error.message, error.statusCode);
      if (onError != null) {
        onError(failure);
      }
      return Result.fail(failure);
    } on ImageProcessException catch (error) {
      final failure = ImageProcessFailure("Process image failure", error.type);
      if (onError != null) {
        onError(failure);
      }
      return Result.fail(failure);
    } catch (error) {
      if (onError != null) {
        onError(UnknownFailure());
      }
      return Result.fail(UnknownFailure());
    }
  }
}
