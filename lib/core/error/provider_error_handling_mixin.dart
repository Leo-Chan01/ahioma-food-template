import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/core/utils/failures.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';

/// Mixin for providers to handle errors consistently
mixin ProviderErrorHandling on ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;

  /// Get the current error message
  String? get errorMessage => _errorMessage;

  /// Check if provider is loading
  bool get isLoading => _isLoading;

  /// Check if provider has an error
  bool get hasError => _errorMessage != null;

  /// Set loading state
  void setLoading({required bool loading}) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message and optionally show snackbar
  void setError(String? error, {bool showSnackbar = true}) {
    _errorMessage = error;
    if (error != null && showSnackbar) {
      GlobalSnackBar.showError(error);
    }
    notifyListeners();
  }

  /// Set error from Failure object
  void setErrorFromFailure(Failure failure, {bool showSnackbar = true}) {
    final userMessage = ErrorHandler.getUserFriendlyMessage(failure);
    setError(userMessage, showSnackbar: showSnackbar);

    // Log the error
    ErrorHandler.logError(
      failure,
      context: runtimeType.toString(),
    );
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Handle async operation with automatic error handling
  Future<T?> handleAsyncOperation<T>({
    required Future<T> Function() operation,
    String? errorContext,
    bool showLoading = true,
    bool showErrorSnackbar = true,
    void Function(T result)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    if (showLoading) setLoading(loading: true);
    clearError();

    try {
      final result = await operation();
      onSuccess?.call(result);
      return result;
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);

      ErrorHandler.logError(
        e,
        stackTrace: stackTrace,
        context: errorContext ?? runtimeType.toString(),
      );

      setErrorFromFailure(failure, showSnackbar: showErrorSnackbar);
      onError?.call(failure);
      return null;
    } finally {
      if (showLoading) setLoading(loading: false);
    }
  }

  /// Show success message
  void showSuccess(String message) {
    GlobalSnackBar.showSuccess(message);
  }

  /// Show warning message
  void showWarning(String message) {
    GlobalSnackBar.showWarning(message);
  }

  /// Show info message
  void showInfo(String message) {
    GlobalSnackBar.showInfo(message);
  }

  /// Reset error and loading state
  void resetErrorState() {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
