/// Lightweight result type to avoid code generation at bootstrap.
abstract class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(Object error, int statusCode) apiFailure,
  });
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success({required this.data});

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Object error, int statusCode) apiFailure,
  }) =>
      success(data);
}

class ApiFailure<T> extends ApiResult<T> {
  final Object error;
  final int statusCode;
  const ApiFailure({required this.error, required this.statusCode});

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Object error, int statusCode) apiFailure,
  }) =>
      apiFailure(error, statusCode);
}
