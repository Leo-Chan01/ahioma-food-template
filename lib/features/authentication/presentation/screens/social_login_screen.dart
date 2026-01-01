import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/login_screen.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/widgets/auth_illustration.dart';
import 'package:ahioma_food_template/shared/widgets/primary_button.dart';
import 'package:ahioma_food_template/shared/widgets/social_login_button.dart';
import 'package:ahioma_food_template/shared/widgets/text_divider.dart';

/// The "Let's you in" screen showing social login options.
///
/// This is a standalone screen that handles its own navigation
/// and social login flow.
class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  static const String path = '/social-login';
  static const String name = 'social-login';

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Illustration
                      AuthIllustration.placeholder(
                        iconWidget: AppIcons.login(
                          size: 80,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        AuthStrings.socialLoginTitle,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SocialLoginButtons.google(
                        onPressed: () => _handleSocialLogin(context, 'Google'),
                      ),

                      const SizedBox(height: 16),

                      SocialLoginButtons.apple(
                        onPressed: () => _handleSocialLogin(context, 'Apple'),
                      ),

                      const SizedBox(height: 32),

                      // Divider
                      const TextDivider(text: AuthStrings.orDivider),

                      const SizedBox(height: 32),

                      // Password sign in button
                      PrimaryButton(
                        onPressed: () {
                          context.pushNamed(LoginScreen.name);
                        },
                        label: AuthStrings.signInWithPassword,
                        borderRadius: 100,
                        width: double.infinity,
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
                            onPressed: () => context.push(SignUpScreen.path),
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
            ],
          ),
        ),
      ),
    );
  }

  void _handleSocialLogin(BuildContext context, String provider) {
    // TODO: Implement social login logic
    // This is where you'd integrate with Firebase Auth, etc.
    _showNotImplemented('$provider login');
  }

  void _showNotImplemented(String feature) {
    GlobalSnackBar.showInfo(AuthStrings.featureNotImplemented);
  }
}
