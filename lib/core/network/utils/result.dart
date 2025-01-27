import 'package:style_me/core/network/failures/failure.dart';

sealed class Result<T> {
  final T? data;
  final Failure? failure;

  const Result({this.data, this.failure});

  factory Result.success(T data) => ResultSuccess(data);

  factory Result.fail(Failure failure) => ResultFail(failure);

  void collect(
    Function(T data) onSuccess,
    Function(Failure failure) onFail,
  ) {
    if (this is ResultSuccess) {
      onSuccess(data as T);
    } else if (this is ResultFail) {
      onFail(failure!);
    }
  }
}

class ResultSuccess<T> extends Result<T> {
  ResultSuccess(T data) : super(data: data);
}

class ResultFail<T> extends Result<T> {
  ResultFail(Failure failure) : super(failure: failure);
}
