import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/home/home_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/create_new_pin_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  static const String path = '/onboarding/verify-email';
  static const String name = 'verify-email';

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        final setupProvider = context.read<AccountSetupProvider>();
        if (!setupProvider.hasCredentials) {
          if (mounted) {
            context.go(SignUpScreen.path);
          }
          return;
        }
        if (setupProvider.registeredCustomerId == null &&
            setupProvider.registrationResult == null) {
          if (mounted) {
            context.go(CreateNewPinScreen.path);
          }
          return;
        }
      } catch (e) {
        // Silently handle errors if context is deactivated
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() {
      _resendCountdown = 60;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCountdown <= 1) {
        timer.cancel();
        setState(() {
          _resendCountdown = 0;
        });
      } else {
        setState(() {
          _resendCountdown -= 1;
        });
      }
    });
  }

  Future<void> _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6 || int.tryParse(otp) == null) {
      GlobalSnackBar.showWarning(
        'Enter the 6-digit verification code sent to your email.',
      );
      return;
    }

    final setupProvider = context.read<AccountSetupProvider>();
    final authProvider = context.read<AuthProvider>();
    final email = setupProvider.registeredEmail ?? setupProvider.email ?? '';

    final fallbackCustomerId = authProvider.pendingVerificationCustomerId;
    if ((setupProvider.registeredCustomerId == null ||
            setupProvider.registeredCustomerId!.isEmpty) &&
        fallbackCustomerId != null &&
        fallbackCustomerId.isNotEmpty) {
      setupProvider.prepareForEmailVerification(
        email: email,
        password: setupProvider.password ?? '',
        customerId: fallbackCustomerId,
      );
    }

    setState(() {
      _isVerifying = true;
    });

    final success = await setupProvider.verifyEmailWithOtp(otp);

    if (!mounted) {
      return;
    }

    if (success) {
      final password = setupProvider.password;
      var loginSuccess = false;
      if (email.isNotEmpty && password != null) {
        loginSuccess = await context.read<AuthProvider>().login(
          email: email,
          password: password,
        );
      }

      if (!mounted) {
        return;
      }

      if (!loginSuccess) {
        GlobalSnackBar.showWarning(
          'Email verified, but we could not sign you in automatically. Please log in manually.',
        );
      } else {
        await context.read<AuthProvider>().fetchCustomerProfile(
          forceRefresh: true,
        );
        if (!mounted) return;

        // Load cart items after successful email verification and login
        // CartService will automatically merge guest cart into authenticated cart
        final cartProvider = context.read<CartProvider>();
        unawaited(cartProvider.loadCartItems());

        GlobalSnackBar.showSuccess('Email verified successfully!');
      }

      setupProvider.resetAll();

      // Navigate to home screen - use goNamed for consistency
      // Ensure we're still mounted before navigating
      if (mounted) {
        try {
          // Use a small delay to ensure all state updates are complete
          // before navigation to avoid deactivated widget errors
          await Future<void>.delayed(const Duration(milliseconds: 100));
          if (mounted) {
            context.go(HomeScreen.path);
          }
        } catch (e) {
          // If navigation fails due to deactivated context,
          // the navigation will be handled by the router automatically
          // when the widget tree stabilizes
        }
      }
    } else {
      final error =
          setupProvider.submissionError ??
          'Verification failed. Please confirm the code and try again.';
      GlobalSnackBar.showError(error);
    }

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _handleResend() async {
    if (_resendCountdown > 0) {
      return;
    }
    final setupProvider = context.read<AccountSetupProvider>();
    setState(() {
      _isResending = true;
    });
    final success = await setupProvider.resendVerificationOtp();
    if (!mounted) {
      return;
    }
    if (success) {
      GlobalSnackBar.showSuccess('Verification code sent. Check your email.');
      _startResendCountdown();
    } else {
      final error =
          setupProvider.submissionError ??
          'Unable to resend verification code. Please try again later.';
      GlobalSnackBar.showError(error);
    }
    setState(() {
      _isResending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final setupProvider = context.watch<AccountSetupProvider>();
    final email = setupProvider.registeredEmail ?? setupProvider.email ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: _isVerifying ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Verify your email',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We just sent a 6-digit verification code to',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                labelText: 'Verification code',
                hintText: 'Enter 6-digit code',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppIcons.lock(
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _handleVerify(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isVerifying ? null : _handleVerify,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Verify email',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _resendCountdown > 0
                      ? 'Resend available in $_resendCountdown s'
                      : "Didn't receive the code?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: _isResending || _resendCountdown > 0
                      ? null
                      : _handleResend,
                  child: _isResending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Resend OTP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
