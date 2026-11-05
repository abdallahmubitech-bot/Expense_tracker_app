/// Base failure type for the domain layer.
///
/// Use cases return these instead of leaking infrastructure exceptions.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Human readable description that the UI can display.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// The requested entity does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// The caller supplied invalid data.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// The local database could not be read or written.
class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// An unexpected error occurred.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
