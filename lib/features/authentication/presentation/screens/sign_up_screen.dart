import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/verify_email_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/widgets/auth_text_field.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';
import 'package:ahioma_food_template/shared/widgets/social_login_group.dart';
import 'package:ahioma_food_template/shared/widgets/text_divider.dart';
import 'package:provider/provider.dart';

/// The sign up screen with email/password form.
///
/// This is a standalone screen that handles its own
/// sign up logic and navigation.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String path = '/sign-up';
  static const String name = 'sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      GlobalSnackBar.showError(AuthStrings.passwordMismatch);
      return;
    }

    if (!_acceptedTerms) {
      GlobalSnackBar.showWarning(AuthStrings.agreeToTerms);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final setupProvider = context.read<AccountSetupProvider>()
        ..resetAll()
        ..resetSubmissionState();

      // Format phone number - ensure it has country code
      var formattedPhoneNumber = phoneNumber.trim();
      String? countryCode;

      if (!formattedPhoneNumber.startsWith('+')) {
        // User didn't include country code - add default (+234 for Nigeria)
        countryCode = '+234';
        if (formattedPhoneNumber.startsWith('0')) {
          // Remove leading 0 (e.g., 08012345678 -> 8012345678)
          formattedPhoneNumber = formattedPhoneNumber.substring(1);
        }
      } else {
        // Extract country code from phone number if it starts with +
        // For now, assume Nigeria (+234) if starts with +234, otherwise extract first few digits
        if (formattedPhoneNumber.startsWith('+234')) {
          countryCode = '+234';
          formattedPhoneNumber = formattedPhoneNumber.substring(
            4,
          ); // Remove +234
        } else {
          // Extract country code (assume first 1-4 digits after +)
          final match = RegExp(
            r'^\+(\d{1,4})',
          ).firstMatch(formattedPhoneNumber);
          if (match != null) {
            countryCode = '+${match.group(1)}';
            formattedPhoneNumber = formattedPhoneNumber.substring(
              match.group(0)!.length,
            );
          }
        }
      }

      // Initialize credentials with formatted phone number
      setupProvider.initialiseCredentials(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: formattedPhoneNumber,
        countryCode: countryCode,
      );

      // Submit registration directly (only sends required fields)
      final success = await setupProvider.submitRegistration();

      if (!mounted) return;

      if (success) {
        // Registration successful - prepare for email verification
        final registeredEmail = setupProvider.registeredEmail ?? email;
        final customerId = setupProvider.registeredCustomerId;

        // Prepare email verification with customer ID and credentials
        setupProvider.prepareForEmailVerification(
          email: registeredEmail,
          password: password,
          customerId: customerId,
        );

        // Show info message about OTP
        if (registeredEmail.isNotEmpty) {
          GlobalSnackBar.showInfo(
            'Enter the 6-digit code sent to $registeredEmail to verify your account.',
          );
        } else {
          GlobalSnackBar.showSuccess(
            'Registration successful! Please verify your email.',
          );
        }

        // Navigate to email verification screen
        if (mounted) {
          context.pushNamed(VerifyEmailScreen.name);
        }
      } else {
        // Registration failed
        final errorMessage =
            setupProvider.submissionError ??
            'Registration failed. Please try again.';
        GlobalSnackBar.showError(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        GlobalSnackBar.showError('${AuthStrings.signUpFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSocialSignUp(String provider) {
    // TODO(KR): Implement social sign up
    GlobalSnackBar.showInfo(AuthStrings.socialSignUpNotImplemented(provider));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: AppIcons.arrowBack(),
                  onPressed: () => context.pop(),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Title
                        Text(
                          AuthStrings.signUpTitle,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // First name field
                        AuthTextField(
                          controller: _firstNameController,
                          hintText: AuthStrings.firstNameHint,
                          prefixIconWidget: AppIcons.user(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AuthStrings.firstNameRequired;
                            }
                            if (value.trim().length < 2) {
                              return AuthStrings.firstNameTooShort;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Last name field
                        AuthTextField(
                          controller: _lastNameController,
                          hintText: AuthStrings.lastNameHint,
                          prefixIconWidget: AppIcons.user(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AuthStrings.lastNameRequired;
                            }
                            if (value.trim().length < 2) {
                              return AuthStrings.lastNameTooShort;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Phone number field
                        AuthTextField(
                          controller: _phoneController,
                          hintText: AuthStrings.phoneNumberHint,
                          prefixIconWidget: AppIcons.phone(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[0-9+ ]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AuthStrings.phoneNumberRequired;
                            }
                            final digits = value.replaceAll(
                              RegExp('[^0-9]'),
                              '',
                            );
                            if (digits.length < 10) {
                              return AuthStrings.phoneNumberTooShort;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Email field
                        AuthTextField(
                          controller: _emailController,
                          hintText: AuthStrings.emailHint,
                          prefixIconWidget: AppIcons.email(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AuthStrings.emailRequired;
                            }
                            // Basic email validation
                            final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return AuthStrings.emailInvalid;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password field
                        AuthTextField(
                          controller: _passwordController,
                          hintText: AuthStrings.passwordHint,
                          prefixIconWidget: AppIcons.password(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          obscureText: true,
                          enablePasswordToggle: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleSignUp(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AuthStrings.passwordRequired;
                            }
                            if (value.length < 6) {
                              return AuthStrings.passwordTooShort;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Confirm password field
                        AuthTextField(
                          controller: _confirmPasswordController,
                          hintText: AuthStrings.confirmPasswordHint,
                          prefixIconWidget: AppIcons.password(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          obscureText: true,
                          enablePasswordToggle: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _handleSignUp(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AuthStrings.passwordRequired;
                            }
                            if (value != _passwordController.text) {
                              return AuthStrings.passwordMismatch;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        CheckboxListTile(
                          value: _acceptedTerms,
                          onChanged: (value) {
                            setState(() => _acceptedTerms = value ?? false);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            AuthStrings.agreementText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.9),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: _handleSignUp,
                            label: AuthStrings.signUpButton,
                            isLoading: _isLoading,
                            borderRadius: 100,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Divider
                        const TextDivider(text: AuthStrings.orContinueWith),

                        const SizedBox(height: 24),

                        // Social login options
                        SocialLoginGroup(
                          buttons: [
                            SocialIconButtons.google(
                              onPressed: () => _handleSocialSignUp('Google'),
                            ),
                            SocialIconButtons.apple(
                              onPressed: () => _handleSocialSignUp('Apple'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Sign in link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AuthStrings.alreadyHaveAccount,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO(KR): Navigate to sign in screen
                                context.pop();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AuthStrings.signInLink,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
