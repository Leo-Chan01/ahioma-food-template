import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/features/authentication/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ahioma_food_template/features/authentication/data/models/customer_model.dart';
import 'package:ahioma_food_template/features/cart/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides authentication state and actions for storefront customers.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthRemoteDataSource? authDataSource,
    SharedPreferences? sharedPreferences,
    CartRemoteDataSource? cartDataSource,
  }) : _authDataSource = authDataSource ?? sl<AuthRemoteDataSource>(),
       _prefs = sharedPreferences ?? sl<SharedPreferences>(),
       _cartDataSource = cartDataSource ?? sl<CartRemoteDataSource>();

  final AuthRemoteDataSource _authDataSource;
  final SharedPreferences _prefs;
  final CartRemoteDataSource _cartDataSource;

  bool _isInitializing = false;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  CustomerModel? _customer;
  String? _errorMessage;
  String? _redirectAfterLogin;
  bool _requiresEmailVerification = false;
  String? _pendingVerificationEmail;
  String? _pendingVerificationCustomerId;

  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  CustomerModel? get customer => _customer;
  String? get errorMessage => _errorMessage;
  String? get redirectAfterLogin => _redirectAfterLogin;
  bool get requiresEmailVerification => _requiresEmailVerification;
  String? get pendingVerificationEmail => _pendingVerificationEmail;
  String? get pendingVerificationCustomerId => _pendingVerificationCustomerId;

  // ignore: use_setters_to_change_properties
  void setRedirectAfterLogin(String? route) {
    _redirectAfterLogin = route;
  }

  Future<CustomerModel?> fetchCustomerProfile({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _customer != null) {
      return _customer;
    }

    final token = _prefs.getString(AppConstants.userTokenKey);
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final profile = await _authDataSource.getCustomerProfile(token: token);
      if (profile != null) {
        _customer = profile;
        _isAuthenticated = true;
        notifyListeners();
      }
      return profile;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AuthProvider] Failed to fetch profile: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return null;
    }
  }

  /// Loads persisted authentication state.
  Future<void> initialize() async {
    if (_isInitializing) return;
    _isInitializing = true;
    notifyListeners();

    final storedToken = _prefs.getString(AppConstants.userTokenKey);
    if (storedToken == null || storedToken.isEmpty) {
      _clearSession(notify: false);
      _isInitializing = false;
      notifyListeners();
      return;
    }

    try {
      _customer = await _authDataSource.getCustomerProfile(token: storedToken);
      _isAuthenticated = _customer != null;
    } catch (_) {
      await _prefs.remove(AppConstants.userTokenKey);
      _clearSession(notify: false);
    }

    _clearEmailVerificationRequirement(notify: false);
    _isInitializing = false;
    notifyListeners();
  }

  /// Attempts to login the customer with email/password.
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final result = await _authDataSource.loginCustomer(
        email: email,
        password: password,
      );

      if (result.accessToken == null || result.accessToken!.isEmpty) {
        throw Exception('Missing access token in response.');
      }

      await _prefs.setString(AppConstants.userTokenKey, result.accessToken!);
      _customer =
          result.customer ??
          await _authDataSource.getCustomerProfile(token: result.accessToken!);
      _isAuthenticated = true;
      _clearEmailVerificationRequirement(notify: false);

      // Merge guest cart into authenticated cart after successful login
      try {
        await _cartDataSource.mergeGuestCartIntoAuthenticatedCart();
        if (kDebugMode) {
          debugPrint(
            '[AuthProvider] Guest cart merged into authenticated cart',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[AuthProvider] Error merging cart: $e');
        }
        // Don't fail login if cart merge fails
      }

      _setLoading(false);
      return true;
    } catch (error) {
      final failure = ErrorHandler.handleException(error);
      _errorMessage = ErrorHandler.getUserFriendlyMessage(failure);
      _clearSession(notify: false);
      await _handlePotentialEmailVerificationFailure(
        error: error,
        email: email,
      );
      _setLoading(false);
      return false;
    }
  }

  /// Clears authentication state and notifies listeners.
  Future<void> logout() async {
    await _prefs.remove(AppConstants.userTokenKey);
    _clearSession();
    _clearEmailVerificationRequirement();
  }

  /// Clears the last error message.
  void resetError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearEmailVerificationRequirement() {
    _clearEmailVerificationRequirement();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  void _clearSession({bool notify = true}) {
    _customer = null;
    _isAuthenticated = false;
    _errorMessage = null;
    _clearEmailVerificationRequirement(notify: false);
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> _handlePotentialEmailVerificationFailure({
    required Object error,
    required String email,
  }) async {
    _requiresEmailVerification = false;
    _pendingVerificationEmail = null;
    _pendingVerificationCustomerId = null;

    if (error is! DioException) {
      return;
    }

    final responseData = error.response?.data;
    if (responseData is! Map<String, dynamic>) {
      return;
    }
    final code = responseData['code'] ?? responseData['error_code'];
    if (code != 'EMAIL_NOT_VERIFIED' && code != 'email_not_verified') {
      return;
    }

    _requiresEmailVerification = true;

    final responseEmail =
        responseData['email'] ??
        (responseData['data'] is Map<String, dynamic>
            ? (responseData['data'] as Map<String, dynamic>)['email']
            : null);
    if (responseEmail is String && responseEmail.isNotEmpty) {
      _pendingVerificationEmail = responseEmail;
    } else {
      _pendingVerificationEmail = email;
    }

    final errorCustomerId = _extractCustomerId(responseData);
    if (errorCustomerId != null && errorCustomerId.isNotEmpty) {
      _pendingVerificationCustomerId = errorCustomerId;
      notifyListeners();
      return;
    }

    try {
      final resendResponse = await _authDataSource.resendCustomerOtp(
        email: email,
      );
      final extractedId = _extractCustomerId(resendResponse);
      if (extractedId != null && extractedId.isNotEmpty) {
        _pendingVerificationCustomerId = extractedId;
      }
    } catch (_) {
      // Swallow resend errors; user can retry from verification screen.
    }

    notifyListeners();
  }

  void _clearEmailVerificationRequirement({bool notify = true}) {
    final hadFlag =
        _requiresEmailVerification ||
        _pendingVerificationEmail != null ||
        _pendingVerificationCustomerId != null;
    _requiresEmailVerification = false;
    _pendingVerificationEmail = null;
    _pendingVerificationCustomerId = null;
    if (notify && hadFlag) {
      notifyListeners();
    }
  }

  String? _extractCustomerId(Map<String, dynamic> envelope) {
    final visited = <Map<String, dynamic>>{};

    String? visit(Map<String, dynamic> map) {
      if (visited.contains(map)) {
        return null;
      }
      visited.add(map);

      final candidates = [map['customerId'], map['customer_id'], map['id']];
      for (final candidate in candidates) {
        if (candidate is String && candidate.isNotEmpty) {
          return candidate;
        }
      }

      final customer = map['customer'];
      if (customer is Map<String, dynamic>) {
        final nested = visit(customer);
        if (nested != null) {
          return nested;
        }
      }

      final data = map['data'];
      if (data is Map<String, dynamic>) {
        final nested = visit(data);
        if (nested != null) {
          return nested;
        }
      }

      return null;
    }

    return visit(envelope);
  }
}
