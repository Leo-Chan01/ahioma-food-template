/// Authentication-related string constants.
///
/// All text used in authentication screens and flows.
/// Organized by screen/feature for easy localization.
class AuthStrings {
  AuthStrings._(); // Private constructor to prevent instantiation

  // ============================================================
  // Social Login Screen
  // ============================================================

  /// Title for social login screen
  static const String socialLoginTitle = "Let's you in";

  /// Label for Facebook login button
  static const String continueWithFacebook = 'Continue with Facebook';

  /// Label for Google login button
  static const String continueWithGoogle = 'Continue with Google';

  /// Label for Apple login button
  static const String continueWithApple = 'Continue with Apple';

  /// Label for Twitter login button
  static const String continueWithTwitter = 'Continue with Twitter';

  /// Divider text between social and password options
  static const String orDivider = 'or';

  /// Button text for password sign in
  static const String signInWithPassword = 'Sign in with password';

  /// Prompt text for users who don't have an account
  static const String dontHaveAccount = "Don't have an account? ";

  /// Link text to navigate to sign up
  static const String signUpLink = 'Sign up';

  // ============================================================
  // Sign Up Screen
  // ============================================================

  /// Title for sign up screen
  static const String signUpTitle = 'Create your\nAccount';

  /// First name field hint text
  static const String firstNameHint = 'First name';

  /// Last name field hint text
  static const String lastNameHint = 'Last name';

  /// Email field hint text
  static const String emailHint = 'Email';

  /// Phone number field hint text
  static const String phoneNumberHint = 'Phone number';

  /// Password field hint text
  static const String passwordHint = 'Password';

  /// Confirm password field hint text
  static const String confirmPasswordHint = 'Confirm password';

  /// Remember me checkbox label
  static const String rememberMe = 'Remember me';

  /// Sign up button text
  static const String signUpButton = 'Sign up';

  /// Divider text before social options
  static const String orContinueWith = 'or continue with';

  /// Prompt text for users who already have an account
  static const String alreadyHaveAccount = 'Already have an account? ';

  /// Link text to navigate to sign in
  static const String signInLink = 'Sign in';

  // ============================================================
  // Sign In Screen (for future use)
  // ============================================================

  /// Title for sign in screen
  static const String signInTitle = 'Welcome back';

  /// Forgot password link text
  static const String forgotPassword = 'Forgot password?';

  /// Sign in button text
  static const String signInButton = 'Sign in';

  // ============================================================
  // Validation Messages
  // ============================================================

  /// Error when email field is empty
  static const String emailRequired = 'Please enter your email';

  /// Error when email format is invalid
  static const String emailInvalid = 'Please enter a valid email';

  /// Error when password field is empty
  static const String passwordRequired = 'Please enter your password';

  /// Error when password is too short
  static const String passwordTooShort =
      'Password must be at least 6 characters';

  /// Error when password is too weak
  static const String passwordTooWeak =
      'Password must contain at least one uppercase letter, '
      'one lowercase letter, and one number';

  /// Error when password confirmation doesn't match
  static const String passwordMismatch = 'Passwords do not match';

  /// Error when name field is empty
  static const String nameRequired = 'Please enter your name';

  /// Error when first name is empty
  static const String firstNameRequired = 'Please enter your first name';

  /// Error when first name is too short
  static const String firstNameTooShort =
      'First name must be at least 2 characters';

  /// Error when last name is empty
  static const String lastNameRequired = 'Please enter your last name';

  /// Error when last name is too short
  static const String lastNameTooShort =
      'Last name must be at least 2 characters';

  /// Error when phone number is empty
  static const String phoneNumberRequired = 'Please enter your phone number';

  /// Error when phone number is too short
  static const String phoneNumberTooShort =
      'Phone number must include at least 10 digits';

  // ============================================================
  // Success Messages
  // ============================================================

  /// Message shown when account is created successfully
  static const String accountCreatedSuccess = 'Account created successfully!';

  /// Message shown when sign in is successful
  static const String signInSuccess = 'Welcome back!';

  /// Message shown when password reset email is sent
  static const String passwordResetSent =
      'Password reset link sent to your email';

  /// Message shown when email is verified
  static const String emailVerified = 'Email verified successfully!';

  // ============================================================
  // Error Messages
  // ============================================================

  /// General sign up error message
  static const String signUpFailed = 'Sign up failed';

  /// General sign in error message
  static const String signInFailed = 'Sign in failed';

  /// Error when email already exists
  static const String emailAlreadyExists =
      'An account with this email already exists';

  /// Error when credentials are invalid
  static const String invalidCredentials = 'Invalid email or password';

  /// Prompt when email needs verification before login
  static const String emailNotVerifiedPrompt =
      'Please verify your email to continue. We just sent you a new code.';

  /// Error when account is disabled
  static const String accountDisabled =
      'This account has been disabled. Please contact support.';

  /// Error when too many requests are made
  static const String tooManyRequests =
      'Too many attempts. Please try again later.';

  /// Error when network is unavailable
  static const String networkError =
      'Network error. Please check your connection.';

  /// Generic error message
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';

  // ============================================================
  // Info Messages
  // ============================================================

  /// Message shown when feature is not yet implemented
  static const String featureNotImplemented =
      'This feature is not yet implemented';

  /// Message shown when social login is not implemented
  static String socialLoginNotImplemented(String provider) =>
      '$provider login is not yet implemented';

  /// Message shown when sign up is not implemented
  static String socialSignUpNotImplemented(String provider) =>
      '$provider sign up not yet implemented';

  // ============================================================
  // Loading States
  // ============================================================

  /// Text shown while signing in
  static const String signingIn = 'Signing in...';

  /// Text shown while signing up
  static const String signingUp = 'Creating account...';

  /// Text shown while sending password reset
  static const String sendingPasswordReset = 'Sending reset link...';

  /// Text shown while verifying email
  static const String verifyingEmail = 'Verifying email...';

  // ============================================================
  // Terms & Privacy
  // ============================================================

  /// Terms and conditions text
  static const String termsAndConditions = 'Terms and Conditions';

  /// Privacy policy text
  static const String privacyPolicy = 'Privacy Policy';

  /// Agreement text for sign up
  static const String agreementText =
      'By signing up, you agree to our Terms and Conditions and Privacy Policy';

  /// Agreement checkbox label
  static const String agreeToTerms = 'I agree to the Terms and Conditions';

  static String loginTitle = 'Login to your\nAccount';
}
