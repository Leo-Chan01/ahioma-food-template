/// Onboarding and account setup string constants.
///
/// All text used in onboarding screens and flows after account creation.
class OnboardingStrings {
  OnboardingStrings._(); // Private constructor to prevent instantiation

  // ============================================================
  // Fill Your Profile Screen
  // ============================================================

  /// Title for fill your profile screen
  static const String fillYourProfile = 'Fill Your Profile';

  /// Full name field label
  static const String fullName = 'Full Name';

  /// Nickname field label
  static const String nickname = 'Nickname';

  /// Date of birth field label
  static const String dateOfBirth = 'Date of Birth';

  /// Email field label
  static const String email = 'Email';

  /// Phone number field label
  static const String phoneNumber = 'Phone Number';

  /// Country code selector label
  static const String countryCode = 'Country Code';

  /// Gender field label
  static const String gender = 'Gender';

  /// Continue button text
  static const String continueButton = 'Continue';

  // ============================================================
  // Set Your Fingerprint Screen
  // ============================================================

  /// Title for set fingerprint screen
  static const String setYourFingerprint = 'Set Your Fingerprint';

  /// Instruction text for fingerprint setup
  static const String addFingerprintInstruction =
      'Add a fingerprint to make your account more secure.';

  /// Second instruction text
  static const String placeFingerInstruction =
      'Please put your finger on the fingerprint scanner to get started.';

  /// Skip button text
  static const String skip = 'Skip';

  // ============================================================
  // Create New PIN Screen
  // ============================================================

  /// Title for create PIN screen
  static const String createNewPIN = 'Create New PIN';

  /// Instruction text for PIN setup
  static const String addPINInstruction =
      'Add a PIN number to make your account more secure.';

  // ============================================================
  // Congratulations Screen
  // ============================================================

  /// Congratulations title
  static const String congratulations = 'Congratulations!';

  /// Success message for account setup completion
  static const String accountReadyMessage =
      'Your account is ready to use. You will be redirected to the Home page in a few seconds..';

  // ============================================================
  // Gender Options
  // ============================================================

  /// Male gender option
  static const String male = 'Male';

  /// Female gender option
  static const String female = 'Female';

  /// Other gender option
  static const String other = 'Other';

  // ============================================================
  // Validation Messages
  // ============================================================

  /// Error when full name is required
  static const String fullNameRequired = 'Please enter your full name';

  /// Error when nickname is required
  static const String nicknameRequired = 'Please enter your nickname';

  /// Error when email is required
  static const String emailRequired = 'Please enter your email';

  /// Error when email format is invalid
  static const String emailInvalid = 'Please enter a valid email';

  /// Error when phone number is required
  static const String phoneNumberRequired = 'Please enter your phone number';

  /// Error when gender is required
  static const String genderRequired = 'Please select your gender';

  /// Error when date of birth is required
  static const String dateOfBirthRequired = 'Please select your date of birth';

  /// Error when PIN is too short
  static const String pinTooShort = 'PIN must be 4 digits';

  /// Error when PIN is too long
  static const String pinTooLong = 'PIN must be 4 digits';
}
