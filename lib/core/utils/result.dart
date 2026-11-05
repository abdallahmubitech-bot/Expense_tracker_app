import '../error/failure.dart';

/// Outcome of an operation that can fail in a recoverable way.
///
/// Use cases return this instead of throwing, so the presentation layer
/// is forced to handle the failure branch.
sealed class Result<T> {
  const Result();

  /// True when the operation succeeded.
  bool get isSuccess => this is Success<T>;

  /// True when the operation failed.
  bool get isFailure => this is Error<T>;

  /// The value when successful, otherwise null.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Error<T>() => null,
      };

  /// The failure when unsuccessful, otherwise null.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Error<T>(:final failure) => failure,
      };

  /// Transforms a successful value while keeping failures untouched.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Success<R>(transform(value)),
      Error<T>(:final failure) => Error<R>(failure),
    };
  }
}

/// Successful outcome carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  /// The produced value.
  final T value;
}

/// Failed outcome carrying a domain [failure].
final class Error<T> extends Result<T> {
  const Error(this.failure);

  /// The reason the operation failed.
  final Failure failure;
}
