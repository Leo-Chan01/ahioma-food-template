import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';
import 'package:ahioma_food_template/features/authentication/authentication.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:ahioma_food_template/features/cart/presentation/provider/cart_provider.dart';
import 'package:ahioma_food_template/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/verify_email_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/profile_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/widgets/auth_text_field.dart';
import 'package:ahioma_food_template/shared/widgets/labeled_checkbox.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';
import 'package:ahioma_food_template/shared/widgets/social_login_group.dart';
import 'package:ahioma_food_template/shared/widgets/text_divider.dart';
import 'package:provider/provider.dart';

/// The sign up screen with email/password form.
///
/// This is a standalone screen that handles its own
/// sign up logic and navigation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({this.redirectPath, super.key});

  static const String path = '/login';
  static const String name = 'login';

  final String? redirectPath;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final authProvider = context.read<AuthProvider>()..resetError();
      try {
        final success = await authProvider.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        if (success) {
          await authProvider.fetchCustomerProfile(forceRefresh: true);
          if (!mounted) return;

          // Load cart items after successful login so badge shows immediately
          // CartService will automatically merge guest cart into authenticated cart
          final cartProvider = context.read<CartProvider>();
          unawaited(cartProvider.loadCartItems());

          GlobalSnackBar.showSuccess(AuthStrings.signInSuccess);
          final targetRoute =
              authProvider.redirectAfterLogin ??
              widget.redirectPath ??
              ProfileScreen.path;
          authProvider.setRedirectAfterLogin(null);
          if (targetRoute == CheckoutScreen.path) {
            context.pushReplacement(targetRoute);
            return;
          }
          context.go(targetRoute);
        } else {
          if (authProvider.requiresEmailVerification) {
            final verificationEmail =
                authProvider.pendingVerificationEmail ??
                _emailController.text.trim();
            final verificationCustomerId =
                authProvider.pendingVerificationCustomerId;

            context.read<AccountSetupProvider>().prepareForEmailVerification(
              email: verificationEmail,
              password: _passwordController.text,
              customerId: verificationCustomerId,
            );

            GlobalSnackBar.showWarning(AuthStrings.emailNotVerifiedPrompt);
            authProvider.clearEmailVerificationRequirement();

            if (mounted) {
              await context.pushNamed(VerifyEmailScreen.name);
            }
          } else {
            final message =
                authProvider.errorMessage ?? AuthStrings.invalidCredentials;
            GlobalSnackBar.showError(message);
          }
        }
      } catch (e) {
        if (!mounted) return;
        GlobalSnackBar.showError('${AuthStrings.signInFailed}: $e');
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
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

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
                          AuthStrings.loginTitle,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 32),

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
                          onSubmitted: (_) => _handleSignIn(),
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

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              unawaited(
                                context.pushNamed(ForgotPasswordScreen.name),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              AuthStrings.forgotPassword,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Remember me checkbox
                        // Center(
                        //   child: LabeledCheckbox(
                        //     label: AuthStrings.rememberMe,
                        //     value: _rememberMe,
                        //     onChanged: (value) {
                        //       setState(() => _rememberMe = value);
                        //     },
                        //   ),
                        // ),
                        const SizedBox(height: 24),

                        // Sign in button
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: _handleSignIn,
                            label: AuthStrings.signInButton,
                            isLoading: isLoading,
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

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AuthStrings.dontHaveAccount,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                unawaited(context.pushNamed(SignUpScreen.name));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AuthStrings.signUpLink,
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
