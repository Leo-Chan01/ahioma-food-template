import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/core/error/error_handler.dart';
import 'package:ahioma_food_template/features/authentication/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ahioma_food_template/core/utils/exceptions.dart';
import 'package:ahioma_food_template/injection_container.dart';

/// Manages the multi-step account setup flow (profile, PIN, fingerprint)
/// before completing customer registration on the storefront API.
class AccountSetupProvider extends ChangeNotifier {
  AccountSetupProvider({AuthRemoteDataSource? authDataSource})
    : _authDataSource = authDataSource ?? sl<AuthRemoteDataSource>();

  final AuthRemoteDataSource _authDataSource;

  // Step 0 – credentials from the initial sign-up form
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _firstName;
  String? _lastName;

  // Step 1 – profile information
  String? _fullName;
  String? _nickname;
  DateTime? _dateOfBirth;
  String? _phoneNumber;
  String? _countryCode;
  String? _gender;
  String? _profileImagePath;

  // API response for the completed registration
  Map<String, dynamic>? _registrationResult;

  // Step 2 – security information
  String? _pin;
  bool _fingerprintEnabled = false;

  // Submission state
  bool _isSubmitting = false;
  String? _submissionError;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  String? get email => _email;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fullName => _fullName;
  String? get nickname => _nickname;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get phoneNumber => _phoneNumber;
  String? get countryCode => _countryCode;
  String? get gender => _gender;
  String? get profileImagePath => _profileImagePath;
  String? get pin => _pin;
  bool get fingerprintEnabled => _fingerprintEnabled;
  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;
  Map<String, dynamic>? get registrationResult => _registrationResult;

  String? get registeredCustomerId {
    // First, try to extract from registration result using comprehensive extraction
    if (_registrationResult != null) {
      final extractedId = _extractCustomerIdFromEnvelope(_registrationResult!);
      if (extractedId != null && extractedId.isNotEmpty) {
        return extractedId;
      }
    }

    // Fallback to direct property access
    final data = _registrationResult?['data'];
    if (data is Map<String, dynamic>) {
      final customer = data['customer'];
      if (customer is Map<String, dynamic>) {
        final id =
            customer['id'] ??
            customer['_id'] ??
            customer['customerId'] ??
            customer['customer_id'];
        if (id != null && id.toString().isNotEmpty) {
          return id.toString();
        }
      }
      final id =
          data['customerId'] ??
          data['customer_id'] ??
          data['id'] ??
          data['_id'];
      if (id != null && id.toString().isNotEmpty) {
        return id.toString();
      }
    }
    final fallback =
        _registrationResult?['customerId'] ??
        _registrationResult?['customer_id'] ??
        _registrationResult?['id'] ??
        _registrationResult?['_id'];
    return fallback != null && fallback.toString().isNotEmpty
        ? fallback.toString()
        : null;
  }

  String? get registeredEmail {
    final data = _registrationResult?['data'];
    if (data is Map<String, dynamic>) {
      final customer = data['customer'];
      if (customer is Map<String, dynamic>) {
        final email = customer['email'];
        if (email is String && email.isNotEmpty) {
          return email;
        }
      }
      final email = data['email'];
      if (email is String && email.isNotEmpty) {
        return email;
      }
    }
    final fallback = _registrationResult?['email'];
    if (fallback is String && fallback.isNotEmpty) {
      return fallback;
    }
    return _email;
  }

  bool get hasCredentials =>
      (_email?.isNotEmpty ?? false) && (_password?.isNotEmpty ?? false);

  bool get isProfileStepComplete {
    // For registration, we only need:
    // - Email (already checked in hasCredentials)
    // - Phone number
    // - Name parts (firstName, lastName derived from fullName or separate fields)
    final hasName =
        (_fullName?.isNotEmpty ?? false) ||
        ((_firstName?.isNotEmpty ?? false) && (_lastName?.isNotEmpty ?? false));
    final hasPhone = _phoneNumber?.isNotEmpty ?? false;
    return hasName && hasPhone;
  }

  bool get isPinStepComplete => _pin != null && _pin!.length == 4;

  // ---------------------------------------------------------------------------
  // Mutations
  // ---------------------------------------------------------------------------
  void initialiseCredentials({
    required String email,
    required String password,
    String? confirmPassword,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? countryCode,
  }) {
    _email = email.trim();
    _password = password;
    _confirmPassword = confirmPassword ?? password;
    if (firstName != null && firstName.trim().isNotEmpty) {
      _firstName = firstName.trim();
    }
    if (lastName != null && lastName.trim().isNotEmpty) {
      _lastName = lastName.trim();
    }
    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      _phoneNumber = phoneNumber.trim();
    }
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      _countryCode = countryCode.trim();
    }
    _syncFullNameFromNameParts();
    notifyListeners();
  }

  void updateProfile({
    required String fullName,
    required String nickname,
    required DateTime dateOfBirth,
    required String email,
    required String phoneNumber,
    required String gender,
    String? countryCode,
    String? profileImagePath,
  }) {
    _fullName = fullName.trim();
    _nickname = nickname.trim();
    _dateOfBirth = dateOfBirth;
    _email = email.trim();
    _phoneNumber = phoneNumber.trim();
    _countryCode = countryCode;
    _gender = gender.trim();
    _profileImagePath = profileImagePath;
    _syncNamePartsFromFullName();
    notifyListeners();
  }

  void updatePin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  void setFingerprintEnabled({required bool enabled}) {
    _fingerprintEnabled = enabled;
    notifyListeners();
  }

  void resetSubmissionState() {
    _isSubmitting = false;
    _submissionError = null;
    _registrationResult = null;
    notifyListeners();
  }

  void resetAll({bool keepEmail = false}) {
    final preservedEmail = keepEmail ? _email : null;
    _email = preservedEmail;
    _password = null;
    _confirmPassword = null;
    _firstName = null;
    _lastName = null;
    _fullName = null;
    _nickname = null;
    _dateOfBirth = null;
    _phoneNumber = null;
    _countryCode = null;
    _gender = null;
    _profileImagePath = null;
    _pin = null;
    _fingerprintEnabled = false;
    _isSubmitting = false;
    _submissionError = null;
    _registrationResult = null;
    notifyListeners();
  }

  void prepareForEmailVerification({
    required String email,
    required String password,
    String? customerId,
  }) {
    _email = email.trim();
    _password = password;
    _confirmPassword = password;

    final existingData =
        (_registrationResult?['data'] as Map<String, dynamic>?) ?? {};
    final existingCustomerId =
        customerId ??
        existingData['customerId'] ??
        existingData['customer_id'] ??
        existingData['id'] ??
        existingData['_id'] ??
        _registrationResult?['customerId'] ??
        _registrationResult?['customer_id'] ??
        _registrationResult?['id'] ??
        _registrationResult?['_id'];

    final updatedData = Map<String, dynamic>.from(existingData)
      ..['email'] = _email;

    if (existingCustomerId != null) {
      final customerIdStr = existingCustomerId.toString().trim();
      if (customerIdStr.isNotEmpty) {
        updatedData['customerId'] = customerIdStr;
        updatedData['customer_id'] = customerIdStr;
        updatedData['id'] = customerIdStr;
      }
    }

    _registrationResult = {
      if (_registrationResult != null) ..._registrationResult!,
      'data': updatedData,
      if (existingCustomerId != null &&
          existingCustomerId.toString().trim().isNotEmpty)
        'customerId': existingCustomerId.toString().trim(),
    };

    notifyListeners();
  }

  /// Verify the customer's email using the provided OTP code.
  Future<bool> verifyEmailWithOtp(String otpCode) async {
    // Try multiple sources for customer ID
    var customerId = registeredCustomerId;

    // If still not found, try to extract directly from registration result
    if ((customerId == null || customerId.isEmpty) &&
        _registrationResult != null) {
      customerId = _extractCustomerIdFromEnvelope(_registrationResult!);
    }

    if (customerId == null || customerId.isEmpty) {
      _submissionError =
          'We could not determine the customer ID for verification. Please resend the code and try again.';
      notifyListeners();
      return false;
    }

    try {
      _isSubmitting = true;
      _submissionError = null;
      notifyListeners();

      final response = await _authDataSource.verifyCustomerEmail(
        customerId: customerId,
        otpCode: otpCode,
      );

      if (!_isSuccessResponse(response)) {
        final message =
            _extractErrorMessage(response) ??
            'Invalid verification code. Please try again.';
        throw ServerException(message: message, statusCode: '400');
      }

      _registrationResult = {
        ...?_registrationResult,
        'emailVerified': true,
        'verificationResponse': response,
      };
      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      _isSubmitting = false;
      final failure = ErrorHandler.handleException(error);
      _submissionError = ErrorHandler.getUserFriendlyMessage(failure);
      notifyListeners();
      if (kDebugMode) {
        debugPrint('[AccountSetupProvider] Email verification failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  /// Resend verification OTP to the user's email.
  Future<bool> resendVerificationOtp() async {
    final emailToUse = registeredEmail;
    if (emailToUse == null || emailToUse.isEmpty) {
      _submissionError = 'We could not determine the email for OTP delivery.';
      notifyListeners();
      return false;
    }

    try {
      _isSubmitting = true;
      _submissionError = null;
      notifyListeners();

      final response = await _authDataSource.resendCustomerOtp(
        email: emailToUse,
      );

      if (!_isSuccessResponse(response)) {
        final message =
            _extractErrorMessage(response) ??
            'Unable to resend verification code. Please try again.';
        throw ServerException(message: message, statusCode: '400');
      }

      final customerId = _extractCustomerIdFromEnvelope(response);
      if (customerId != null && customerId.isNotEmpty) {
        final existingData =
            (_registrationResult?['data'] as Map<String, dynamic>?) ?? {};
        final updatedData = Map<String, dynamic>.from(existingData)
          ..['customerId'] = customerId
          ..['customer_id'] = customerId
          ..['id'] = customerId;
        _registrationResult = {
          if (_registrationResult != null) ..._registrationResult!,
          'data': updatedData,
          'customerId': customerId,
          'customer_id': customerId,
        };
        notifyListeners();
      }

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      _isSubmitting = false;
      final failure = ErrorHandler.handleException(error);
      _submissionError = ErrorHandler.getUserFriendlyMessage(failure);
      notifyListeners();
      if (kDebugMode) {
        debugPrint('[AccountSetupProvider] Resend OTP failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Submission
  // ---------------------------------------------------------------------------
  Future<bool> submitRegistration() async {
    // Only check for required fields: credentials (email, password) and name parts
    if (!hasCredentials) {
      _submissionError =
          'Incomplete information. Please provide email and password.';
      notifyListeners();
      return false;
    }

    final (firstName, lastName) = _deriveNameParts();
    final phoneNumber = _buildPhoneNumber();
    if (phoneNumber == null || phoneNumber.isEmpty) {
      _submissionError =
          'Invalid phone number. Please review your profile details.';
      notifyListeners();
      return false;
    }

    // Build payload with ONLY required fields
    // Based on API documentation, only these 5 fields are required:
    // firstName, lastName, email, phoneNumber, password
    final payload = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': _email,
      'phoneNumber': phoneNumber,
      'password': _password,
    };

    // Note: Optional fields (nickname, gender, dateOfBirth, pin, fingerprintEnabled, profileImage)
    // are NOT included in the initial registration. These can be added later via profile update.
    // The server error "Cannot read properties of undefined (reading 'map')" was likely
    // caused by sending optional fields that the server wasn't expecting or were in wrong format.

    if (kDebugMode) {
      debugPrint('[AccountSetupProvider] Registration payload: $payload');
      debugPrint(
        '[AccountSetupProvider] Payload keys: ${payload.keys.toList()}',
      );
    }

    try {
      _isSubmitting = true;
      _submissionError = null;
      notifyListeners();

      final response = await _authDataSource.registerCustomer(payload);

      if (!_isSuccessResponse(response)) {
        final message =
            _extractErrorMessage(response) ??
            'Unable to complete registration. Please try again.';
        final statusCode = _extractStatusCode(response) ?? '400';

        throw ServerException(message: message, statusCode: statusCode);
      }

      _registrationResult = response;

      // Extract and ensure customer ID is stored properly
      final customerId = _extractCustomerIdFromEnvelope(response);
      if (customerId != null && customerId.isNotEmpty) {
        final existingData = (response['data'] as Map<String, dynamic>?) ?? {};
        final updatedData = Map<String, dynamic>.from(existingData)
          ..['customerId'] = customerId;
        _registrationResult = {
          ...response,
          'data': updatedData,
          'customerId': customerId,
        };
      }

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      _isSubmitting = false;
      final failure = ErrorHandler.handleException(error);
      _submissionError = ErrorHandler.getUserFriendlyMessage(failure);
      notifyListeners();
      if (kDebugMode) {
        debugPrint('[AccountSetupProvider] Registration failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  bool _isSuccessResponse(Map<String, dynamic> response) {
    final successValue = response['success'];
    if (successValue is bool) {
      return successValue;
    }
    final statusCode = _extractStatusCode(response);
    if (statusCode != null) {
      final code = int.tryParse(statusCode);
      if (code != null && code >= 200 && code < 300) {
        return true;
      }
    }
    return true;
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    if (response['message'] is String) {
      return response['message'] as String;
    }
    if (response['error'] is String) {
      return response['error'] as String;
    }
    if (response['errors'] is List) {
      return (response['errors'] as List).join(', ');
    }
    if (response['data'] is Map<String, dynamic>) {
      final data = response['data'] as Map<String, dynamic>;
      if (data['message'] is String) {
        return data['message'] as String;
      }
      if (data['error'] is String) {
        return data['error'] as String;
      }
    }
    return null;
  }

  String? _extractStatusCode(Map<String, dynamic> response) {
    final code = response['statusCode'] ?? response['code'];
    if (code == null) {
      return null;
    }
    return code.toString();
  }

  String? _extractCustomerIdFromEnvelope(Map<String, dynamic> envelope) {
    final visited = <Map<String, dynamic>>{};

    String? visit(Map<String, dynamic> map) {
      if (visited.contains(map)) {
        return null;
      }
      visited.add(map);

      // Check multiple possible keys for customer ID
      final candidates = [
        map['customerId'],
        map['customer_id'],
        map['id'],
        map['_id'],
      ];
      for (final candidate in candidates) {
        if (candidate != null) {
          final candidateStr = candidate.toString().trim();
          if (candidateStr.isNotEmpty) {
            return candidateStr;
          }
        }
      }

      // Check nested customer object
      final customer = map['customer'];
      if (customer is Map<String, dynamic>) {
        final nested = visit(customer);
        if (nested != null && nested.isNotEmpty) {
          return nested;
        }
      }

      // Check nested data object
      final data = map['data'];
      if (data is Map<String, dynamic>) {
        final nested = visit(data);
        if (nested != null && nested.isNotEmpty) {
          return nested;
        }
      }

      // Check nested result object (sometimes API wraps in 'result')
      final result = map['result'];
      if (result is Map<String, dynamic>) {
        final nested = visit(result);
        if (nested != null && nested.isNotEmpty) {
          return nested;
        }
      }

      return null;
    }

    return visit(envelope);
  }

  (String firstName, String lastName) _deriveNameParts() {
    final cachedFirst = _firstName?.trim();
    final cachedLast = _lastName?.trim();
    if ((cachedFirst?.isNotEmpty ?? false) &&
        (cachedLast?.isNotEmpty ?? false)) {
      return (cachedFirst!, cachedLast!);
    }

    final trimmedFullName = (_fullName ?? '').trim();
    if (trimmedFullName.isEmpty) {
      final fallbackFirst = cachedFirst?.isNotEmpty ?? false
          ? cachedFirst!
          : 'Customer';
      final fallbackLast = cachedLast?.isNotEmpty ?? false
          ? cachedLast!
          : 'User';
      return (fallbackFirst, fallbackLast);
    }

    final parts = trimmedFullName.split(RegExp(r'\s+'));
    final derivedFirst = cachedFirst?.isNotEmpty ?? false
        ? cachedFirst!
        : parts.first;
    final remaining = parts.length > 1
        ? parts.sublist(1).join(' ').trim()
        : cachedLast?.isNotEmpty ?? false
        ? cachedLast!
        : (_nickname?.trim().isNotEmpty ?? false)
        ? _nickname!.trim()
        : 'User';

    if (derivedFirst.isNotEmpty) {
      _firstName = derivedFirst;
    }
    if (remaining.isNotEmpty) {
      _lastName = remaining;
    }

    return (derivedFirst, remaining.isEmpty ? 'User' : remaining);
  }

  String? _buildPhoneNumber() {
    final rawPhone = _phoneNumber?.replaceAll(RegExp(r'\s+'), '');
    if (rawPhone == null || rawPhone.isEmpty) {
      return null;
    }
    final rawCountryCode = _countryCode?.replaceAll(RegExp(r'\s+'), '') ?? '';

    if (rawCountryCode.isEmpty) {
      return rawPhone;
    }

    final sanitizedCountryCode = rawCountryCode.startsWith('+')
        ? rawCountryCode
        : '+$rawCountryCode';
    final sanitizedPhone = rawPhone.startsWith('+')
        ? rawPhone.substring(1)
        : rawPhone;

    return '$sanitizedCountryCode$sanitizedPhone';
  }

  void _syncFullNameFromNameParts() {
    final parts = <String>[
      if (_firstName?.trim().isNotEmpty ?? false) _firstName!.trim(),
      if (_lastName?.trim().isNotEmpty ?? false) _lastName!.trim(),
    ];
    if (parts.isNotEmpty) {
      _fullName = parts.join(' ').trim();
    }
  }

  void _syncNamePartsFromFullName() {
    final trimmedFullName = (_fullName ?? '').trim();
    if (trimmedFullName.isEmpty) {
      return;
    }
    final parts = trimmedFullName.split(RegExp(r'\s+'));
    _firstName = parts.first;
    _lastName = parts.length > 1
        ? parts.sublist(1).join(' ').trim()
        : (_lastName?.isNotEmpty ?? false)
        ? _lastName
        : (_nickname?.trim().isNotEmpty ?? false)
        ? _nickname!.trim()
        : 'User';
  }
}
