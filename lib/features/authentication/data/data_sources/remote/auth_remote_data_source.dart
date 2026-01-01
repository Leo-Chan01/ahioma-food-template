import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/features/authentication/data/models/customer_model.dart';
import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';

/// Remote data source for authentication operations
class AuthRemoteDataSource {
  AuthRemoteDataSource(Dio dio) : _api = StorefrontApiService(dio);

  final StorefrontApiService _api;

  /// Register a new storefront customer
  Future<Map<String, dynamic>> registerCustomer(
    Map<String, dynamic> payload,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint(
          '[AuthRemoteDataSource] Registering customer with payload: $payload',
        );
      }
      final httpResponse = await _api.registerCustomer(payload);
      final statusCode = httpResponse.response.statusCode;
      if (kDebugMode) {
        debugPrint(
          '[AuthRemoteDataSource] Registration response: '
          'status=$statusCode data=${httpResponse.data}',
        );
      }
      final envelope = _extractEnvelope(httpResponse.data);
      if (statusCode != null) {
        envelope['statusCode'] = statusCode;
      }
      return envelope;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthRemoteDataSource] Error registering customer: $e');
        if (e is DioException) {
          debugPrint(
            '[AuthRemoteDataSource] Error response: ${e.response?.data}',
          );
          debugPrint(
            '[AuthRemoteDataSource] Error status: ${e.response?.statusCode}',
          );
        }
      }
      rethrow;
    }
  }

  /// Verify customer email with OTP (public)
  Future<Map<String, dynamic>> verifyCustomerEmail({
    required String customerId,
    required String otpCode,
  }) async {
    try {
      final httpResponse = await _api.verifyCustomerEmail({
        'customerId': customerId,
        'otpCode': otpCode,
      });
      final envelope = _extractEnvelope(httpResponse.data)
        ..['statusCode'] = httpResponse.response.statusCode;
      return envelope;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthRemoteDataSource] Error verifying email: $e');
      }
      rethrow;
    }
  }

  /// Resend verification OTP to customer email (public)
  Future<Map<String, dynamic>> resendCustomerOtp({
    required String email,
  }) async {
    try {
      final httpResponse = await _api.resendCustomerOtp({'email': email});
      final envelope = _extractEnvelope(httpResponse.data)
        ..['statusCode'] = httpResponse.response.statusCode;
      return envelope;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthRemoteDataSource] Error resending OTP: $e');
      }
      rethrow;
    }
  }

  /// Login a storefront customer
  Future<CustomerAuthResult> loginCustomer({
    required String email,
    required String password,
  }) async {
    try {
      final httpResponse = await _api.loginCustomer(<String, dynamic>{
        'email': email,
        'password': password,
      });
      final envelope = _extractEnvelope(httpResponse.data)
        ..['statusCode'] = httpResponse.response.statusCode;
      return _parseAuthResult(envelope);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthRemoteDataSource] Error logging in customer: $e');
      }
      rethrow;
    }
  }

  /// Fetch the authenticated customer profile
  Future<CustomerModel?> getCustomerProfile({required String token}) async {
    try {
      final httpResponse = await _api.getCustomerProfile(
        authorization: 'Bearer $token',
      );
      final envelope = _extractEnvelope(httpResponse.data);
      return _extractCustomer(envelope['data'] ?? envelope);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[AuthRemoteDataSource] Error fetching customer profile: $e',
        );
      }
      rethrow;
    }
  }

  Map<String, dynamic> _extractEnvelope(Object? data) {
    if (data == null) return {};
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'data': data};
  }

  CustomerAuthResult _parseAuthResult(Map<String, dynamic> envelope) {
    final data = envelope['data'];
    if (data is Map<String, dynamic>) {
      final token = _extractToken(data);
      final refreshToken = _extractRefreshToken(data);
      final customer = _extractCustomer(data);
      return CustomerAuthResult(
        accessToken: token,
        refreshToken: refreshToken,
        customer: customer,
      );
    }
    final token = _extractToken(envelope);
    final refreshToken = _extractRefreshToken(envelope);
    final customer = _extractCustomer(envelope);
    return CustomerAuthResult(
      accessToken: token,
      refreshToken: refreshToken,
      customer: customer,
    );
  }

  String? _extractToken(Map<String, dynamic> data) {
    final token =
        data['token'] ??
        data['accessToken'] ??
        data['access_token'] ??
        data['jwt'] ??
        (data['tokens'] is Map
            ? (data['tokens'] as Map<dynamic, dynamic>)['accessToken'] ??
                  (data['tokens'] as Map<dynamic, dynamic>)['access_token']
            : null);
    return token is String ? token : token?.toString();
  }

  String? _extractRefreshToken(Map<String, dynamic> data) {
    final token =
        data['refreshToken'] ??
        data['refresh_token'] ??
        (data['tokens'] is Map
            ? (data['tokens'] as Map<dynamic, dynamic>)['refreshToken'] ??
                  (data['tokens'] as Map<dynamic, dynamic>)['refresh_token']
            : null);
    return token is String ? token : token?.toString();
  }

  CustomerModel? _extractCustomer(Object? data) {
    if (data == null) return null;
    Map<String, dynamic>? json;

    if (data is Map<String, dynamic>) {
      if (data['customer'] is Map<String, dynamic>) {
        json = Map<String, dynamic>.from(data['customer'] as Map);
      } else if (data['profile'] is Map<String, dynamic>) {
        json = Map<String, dynamic>.from(data['profile'] as Map);
      } else if (data.containsKey('id') && data.containsKey('email')) {
        json = Map<String, dynamic>.from(data);
      }
    }

    if (json == null) return null;

    try {
      return CustomerModel.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthRemoteDataSource] Error parsing customer: $e');
        debugPrint('[AuthRemoteDataSource] Customer JSON: $json');
      }
      rethrow;
    }
  }
}

class CustomerAuthResult {
  const CustomerAuthResult({
    this.accessToken,
    this.refreshToken,
    this.customer,
  });

  final String? accessToken;
  final String? refreshToken;
  final CustomerModel? customer;
}
