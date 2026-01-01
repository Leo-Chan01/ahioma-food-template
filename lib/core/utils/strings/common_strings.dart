/// Common app-wide string constants.
///
/// General text used throughout the app that doesn't belong
/// to a specific feature.
class CommonStrings {
  CommonStrings._(); // Private constructor to prevent instantiation

  // ============================================================
  // General Actions
  // ============================================================

  /// Generic continue button text
  static const String continueText = 'Continue';

  /// Generic cancel button text
  static const String cancel = 'Cancel';

  /// Generic save button text
  static const String save = 'Save';

  /// Generic delete button text
  static const String delete = 'Delete';

  /// Generic edit button text
  static const String edit = 'Edit';

  /// Generic done button text
  static const String done = 'Done';

  /// Generic close button text
  static const String close = 'Close';

  /// Generic back button text
  static const String back = 'Back';

  /// Generic next button text
  static const String next = 'Next';

  /// Generic submit button text
  static const String submit = 'Submit';

  /// Generic confirm button text
  static const String confirm = 'Confirm';

  /// Generic retry button text
  static const String retry = 'Retry';

  /// Generic refresh button text
  static const String refresh = 'Refresh';

  /// Generic skip button text
  static const String skip = 'Skip';

  /// Generic apply button text
  static const String apply = 'Apply';

  // ============================================================
  // Common Labels
  // ============================================================

  /// Search placeholder text
  static const String search = 'Search';

  /// Filter label
  static const String filter = 'Filter';

  /// Sort label
  static const String sort = 'Sort';

  /// Settings label
  static const String settings = 'Settings';

  /// Profile label
  static const String profile = 'Profile';

  /// Help label
  static const String help = 'Help';

  /// About label
  static const String about = 'About';

  /// Notifications label
  static const String notifications = 'Notifications';

  /// Messages label
  static const String messages = 'Messages';

  /// Home label
  static const String home = 'Home';

  // ============================================================
  // Status Messages
  // ============================================================

  /// Loading text
  static const String loading = 'Loading...';

  /// Processing text
  static const String processing = 'Processing...';

  /// Please wait text
  static const String pleaseWait = 'Please wait...';

  /// Success message
  static const String success = 'Success!';

  /// Error message
  static const String error = 'Error';

  /// Warning message
  static const String warning = 'Warning';

  /// Info message
  static const String info = 'Info';

  // ============================================================
  // Empty States
  // ============================================================

  /// No data available text
  static const String noDataAvailable = 'No data available';

  /// No results found text
  static const String noResultsFound = 'No results found';

  /// Empty list text
  static const String emptyList = 'Nothing to show here';

  /// No items text
  static const String noItems = 'No items';

  /// No notifications text
  static const String noNotifications = 'No notifications';

  /// No messages text
  static const String noMessages = 'No messages';

  // ============================================================
  // Confirmation Dialogs
  // ============================================================

  /// Are you sure prompt
  static const String areYouSure = 'Are you sure?';

  /// Delete confirmation message
  static const String deleteConfirmation =
      'Are you sure you want to delete this?';

  /// Discard changes confirmation
  static const String discardChanges =
      'Are you sure you want to discard changes?';

  /// Logout confirmation
  static const String logoutConfirmation = 'Are you sure you want to logout?';

  /// Yes option
  static const String yes = 'Yes';

  /// No option
  static const String no = 'No';

  // ============================================================
  // Time & Date
  // ============================================================

  /// Today text
  static const String today = 'Today';

  /// Yesterday text
  static const String yesterday = 'Yesterday';

  /// Tomorrow text
  static const String tomorrow = 'Tomorrow';

  /// Just now text
  static const String justNow = 'Just now';

  /// Minutes ago format
  static String minutesAgo(int minutes) => '$minutes minutes ago';

  /// Hours ago format
  static String hoursAgo(int hours) => '$hours hours ago';

  /// Days ago format
  static String daysAgo(int days) => '$days days ago';

  // ============================================================
  // Network & Connectivity
  // ============================================================

  /// No internet connection message
  static const String noInternetConnection = 'No internet connection';

  /// No internet connection title (title case)
  static const String noInternetConnectionTitle = 'No Internet Connection';

  /// Connection restored message
  static const String connectionRestored = 'Connection restored';

  /// Slow internet message
  static const String slowConnection = 'Slow internet connection';

  /// Offline mode message
  static const String offlineMode = 'You are offline';

  /// Reconnecting message
  static const String reconnecting = 'Reconnecting...';

  /// Checking connection message
  static const String checking = 'Checking...';

  /// No internet description message
  static const String noInternetDescription =
      'Please check your internet connection and try again';

  // ============================================================
  // Form Fields
  // ============================================================

  /// Required field indicator
  static const String required = 'Required';

  /// Optional field indicator
  static const String optional = 'Optional';

  /// Select placeholder
  static const String select = 'Select';

  /// Choose placeholder
  static const String choose = 'Choose';

  /// Enter text placeholder
  static const String enter = 'Enter';

  // ============================================================
  // Pagination
  // ============================================================

  /// Load more text
  static const String loadMore = 'Load more';

  /// No more items text
  static const String noMoreItems = 'No more items';

  /// End of list text
  static const String endOfList = "You've reached the end";

  /// Loading more text
  static const String loadingMore = 'Loading more...';

  // ============================================================
  // Accessibility
  // ============================================================

  /// Close button semantic label
  static const String closeButtonLabel = 'Close';

  /// Back button semantic label
  static const String backButtonLabel = 'Go back';

  /// Menu button semantic label
  static const String menuButtonLabel = 'Open menu';

  /// Search button semantic label
  static const String searchButtonLabel = 'Search';
}
