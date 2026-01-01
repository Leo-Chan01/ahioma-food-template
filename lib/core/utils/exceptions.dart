/// Base exception class for data layer exceptions
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final String statusCode;

  @override
  String toString() => '$runtimeType: $message (Code: $statusCode)';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException({
    required super.message,
    required super.statusCode,
  });
}

/// Exception thrown when there's a cache error
class CacheException extends AppException {
  const CacheException({
    required super.message,
    required super.statusCode,
  });
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    required super.statusCode,
  });
}
