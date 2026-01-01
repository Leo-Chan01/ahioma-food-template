import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ahioma_food_template/core/utils/exceptions.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';

/// Centralized error handler for consistent error handling across the app
class ErrorHandler {
  ErrorHandler._();

  /// Convert exceptions to Failure objects
  static Failure handleException(Object exception, [StackTrace? stackTrace]) {
    dev.log(
      'Error occurred: $exception',
      name: 'ErrorHandler',
      error: exception,
      stackTrace: stackTrace,
    );

    if (exception is DioException) {
      return _handleDioException(exception);
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: int.tryParse(exception.statusCode),
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: int.tryParse(exception.statusCode),
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: int.tryParse(exception.statusCode),
      );
    } else if (exception is SocketException) {
      return const NetworkFailure(
        message: 'No internet connection. Please check your network.',
      );
    } else if (exception is FormatException) {
      return ValidationFailure(
        message: exception.message,
      );
    } else {
      return ServerFailure(
        message: exception.toString(),
      );
    }
  }

  /// Handle DioException specifically
  static Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          message:
              'Request timeout. '
              'Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.cancel:
        return const ServerFailure(
          message: 'Request was cancelled',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          final errorMessage = exception.error.toString().toLowerCase();
          if (errorMessage.contains('failed host lookup') ||
              errorMessage.contains('nodename nor servname provided')) {
            return const NetworkFailure(
              message:
                  'Unable to reach the server. '
                  'Please check your internet connection or try again later.',
            );
          }
          return const NetworkFailure(
            message: 'No internet connection. Please check your network.',
          );
        }
        // Check for host lookup in error message
        final errorMsg = exception.message?.toLowerCase() ?? '';
        if (errorMsg.contains('failed host lookup') ||
            errorMsg.contains('connection errored')) {
          return const NetworkFailure(
            message:
                'Unable to reach the server. '
                'Please check your internet connection or try again later.',
          );
        }
        return ServerFailure(
          message: exception.message ?? 'An unexpected error occurred',
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          message: 'Security certificate error. Please try again later.',
        );
    }
  }

  /// Handle bad response from server
  static Failure _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    // Extract error message from response
    var errorMessage = 'An error occurred';

    if (data is Map) {
      errorMessage =
          data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          errorMessage;
    } else if (data is String) {
      errorMessage = data;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(
          message: errorMessage.isEmpty
              ? 'Invalid request. Please check your input.'
              : errorMessage,
          code: statusCode,
        );

      case 401:
        return AuthFailure(
          message: errorMessage.isEmpty
              ? 'Session expired. Please log in again.'
              : errorMessage,
          code: statusCode,
        );

      case 403:
        return PermissionFailure(
          message: errorMessage.isEmpty
              ? 'You do not have permission to perform this action.'
              : errorMessage,
          code: statusCode,
        );

      case 404:
        return ServerFailure(
          message: errorMessage.isEmpty ? 'Resource not found' : errorMessage,
          code: statusCode,
        );

      case 409:
        return ValidationFailure(
          message: errorMessage.isEmpty
              ? 'This resource already exists or conflicts with existing data.'
              : errorMessage,
          code: statusCode,
        );

      case 422:
        return ValidationFailure(
          message: errorMessage.isEmpty
              ? 'Invalid data submitted. Please check and try again.'
              : errorMessage,
          code: statusCode,
        );

      case 429:
        return ServerFailure(
          message: 'Too many requests. Please wait and try again.',
          code: statusCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: 'Server error. Please try again later.',
          code: statusCode,
        );

      default:
        return ServerFailure(
          message: errorMessage.isEmpty
              ? 'An unexpected error occurred'
              : errorMessage,
          code: statusCode,
        );
    }
  }

  /// Get user-friendly error message from Failure
  static String getUserFriendlyMessage(Failure failure) {
    // Check for specific error patterns and provide better messages
    final message = failure.message.toLowerCase();

    // Duplicate key errors (MongoDB)
    if (message.contains('e11000 duplicate key error')) {
      if (message.contains('phonenumber')) {
        return 'This phone number is already registered. '
            'Please use a different phone number or try logging in.';
      } else if (message.contains('email')) {
        return 'This email address is already registered. '
            'Please use a different email or try logging in.';
      } else if (message.contains('username')) {
        return 'This username is already taken. '
            'Please choose a different username.';
      } else {
        return 'An account with these details already exists. '
            'Please try logging in or use different details.';
      }
    }

    // Network errors
    if (message.contains('timeout')) {
      return 'Request timed out. Please check your internet connection '
          'and try again.';
    }

    if (message.contains('connection') ||
        message.contains('network') ||
        message.contains('failed host lookup') ||
        message.contains('nodename nor servname')) {
      return 'Unable to connect to server. '
          'Please check your internet connection and try again.';
    }

    // Token/Auth errors
    if (message.contains('token') || message.contains('unauthorized')) {
      return 'Your session has expired. Please log in again.';
    }

    // Validation errors
    if (message.contains('validation') || message.contains('invalid')) {
      return failure.message; // Use original message for validation errors
    }

    // Default to original message if no pattern matches
    return failure.message;
  }

  /// Check if error requires user re-authentication
  static bool requiresReAuth(Failure failure) {
    if (failure is AuthFailure) return true;

    final message = failure.message.toLowerCase();
    return message.contains('token') ||
        message.contains('unauthorized') ||
        message.contains('session expired') ||
        failure.code == 401;
  }

  /// Check if error is a network connectivity issue
  static bool isNetworkError(Failure failure) {
    if (failure is NetworkFailure) return true;

    final message = failure.message.toLowerCase();
    return message.contains('network') ||
        message.contains('connection') ||
        message.contains('internet') ||
        message.contains('timeout');
  }

  /// Check if error is retryable
  static bool isRetryable(Failure failure) {
    // Network errors are retryable
    if (isNetworkError(failure)) return true;

    // Server errors (5xx) are retryable
    if (failure.code != null && failure.code! >= 500 && failure.code! < 600) {
      return true;
    }

    // Timeout errors are retryable
    if (failure.message.toLowerCase().contains('timeout')) return true;

    return false;
  }

  /// Log error for debugging and monitoring
  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    dev.log(
      'Error${context != null ? ' in $context' : ''}: $error',
      name: 'ErrorHandler',
      error: error,
      stackTrace: stackTrace,
    );

    if (additionalData != null && additionalData.isNotEmpty) {
      dev.log(
        'Additional data: $additionalData',
        name: 'ErrorHandler',
      );
    }

    // TODO(KINGRAYM): Send to crash reporting service
    //(e.g., Sentry, Crashlytics)
    // Example:
    // Sentry.captureException(
    //   error,
    //   stackTrace: stackTrace,
    //   hint: Hint.withMap({
    //     'context': context,
    //     ...?additionalData,
    //   }),
    // );
  }
}
