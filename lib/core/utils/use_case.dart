/// Marker interface implemented by every use case.
///
/// Keeps the domain layer uniform and makes use cases easy to discover.
abstract interface class UseCase {
  /// Name used in logs and debug output.
  String get name;
}
