import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/onboarding_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/create_new_pin_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/fill_your_profile_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/verify_email_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:provider/provider.dart';

class SetYourFingerprintScreen extends StatefulWidget {
  const SetYourFingerprintScreen({super.key});

  static const String path = '/onboarding/set-fingerprint';
  static const String name = 'set-fingerprint';

  @override
  State<SetYourFingerprintScreen> createState() =>
      _SetYourFingerprintScreenState();
}

class _SetYourFingerprintScreenState extends State<SetYourFingerprintScreen> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AccountSetupProvider>();
      if (!provider.hasCredentials) {
        context.goNamed(SignUpScreen.name);
        return;
      }
      if (!provider.isProfileStepComplete) {
        context.goNamed(FillYourProfileScreen.name);
        return;
      }
      if (!provider.isPinStepComplete) {
        context.goNamed(CreateNewPinScreen.name);
      }
    });
  }

  void _handleFingerprintSetup() {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate fingerprint scan delay before completing registration
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      await _completeRegistration(enableFingerprint: true);
    });
  }

  Future<void> _handleSkip() async {
    if (_isProcessing) return;
    await _completeRegistration(enableFingerprint: false);
  }

  Future<void> _completeRegistration({
    required bool enableFingerprint,
  }) async {
    final provider = context.read<AccountSetupProvider>()
      ..setFingerprintEnabled(enabled: enableFingerprint);

    setState(() {
      _isProcessing = true;
    });

    final success = await provider.submitRegistration();
    if (!mounted) {
      return;
    }

    if (success) {
      setState(() {
        _isProcessing = false;
      });

      final otpEmail = provider.registeredEmail ?? provider.email;
      if (otpEmail != null && otpEmail.isNotEmpty) {
        GlobalSnackBar.showInfo(
          'Enter the 6-digit code sent to $otpEmail to verify your account.',
        );
      }

      if (!mounted) return;

      context.pushNamed(VerifyEmailScreen.name);
    } else {
      setState(() {
        _isProcessing = false;
      });
      final errorMessage =
          provider.submissionError ?? 'Failed to complete registration.';
      GlobalSnackBar.showError(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          OnboardingStrings.setYourFingerprint,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // First instruction
                      Text(
                        OnboardingStrings.addFingerprintInstruction,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      // Fingerprint Icon
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: _isProcessing
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : AppIcons.fingerprint(
                                color: colorScheme.onSurface,
                                size: 200,
                              ),
                      ),
                      const SizedBox(height: 60),
                      // Second instruction
                      Text(
                        OnboardingStrings.placeFingerInstruction,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isProcessing ? null : _handleSkip,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          OnboardingStrings.skip,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isProcessing
                            ? null
                            : _handleFingerprintSetup,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          OnboardingStrings.continueButton,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
