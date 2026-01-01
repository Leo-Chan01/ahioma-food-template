/// Defines the different types of search modes available in the app
enum SearchMode {
  products,
  wallet,
  orders,
  notifications,
  general,
}

extension SearchModeExtension on SearchMode {
  /// Get the storage key for recent searches specific to this mode
  String get recentSearchesKey {
    switch (this) {
      case SearchMode.products:
        return 'recent_searches_products';
      case SearchMode.wallet:
        return 'recent_searches_wallet';
      case SearchMode.orders:
        return 'recent_searches_orders';
      case SearchMode.notifications:
        return 'recent_searches_notifications';
      case SearchMode.general:
        return 'recent_searches_general';
    }
  }

  /// Get the placeholder text for this search mode
  String get placeholderText {
    switch (this) {
      case SearchMode.products:
        return 'Search products...';
      case SearchMode.wallet:
        return 'Search transactions...';
      case SearchMode.orders:
        return 'Search orders...';
      case SearchMode.notifications:
        return 'Search notifications...';
      case SearchMode.general:
        return 'Search...';
    }
  }

  /// Get the display name for this search mode
  String get displayName {
    switch (this) {
      case SearchMode.products:
        return 'Products';
      case SearchMode.wallet:
        return 'Wallet';
      case SearchMode.orders:
        return 'Orders';
      case SearchMode.notifications:
        return 'Notifications';
      case SearchMode.general:
        return 'Search';
    }
  }

  /// Parse SearchMode from string (for query parameters)
  static SearchMode fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'products':
        return SearchMode.products;
      case 'wallet':
        return SearchMode.wallet;
      case 'orders':
        return SearchMode.orders;
      case 'notifications':
        return SearchMode.notifications;
      case 'general':
        return SearchMode.general;
      default:
        return SearchMode.general;
    }
  }

  /// Convert SearchMode to string (for query parameters)
  String get stringValue {
    switch (this) {
      case SearchMode.products:
        return 'products';
      case SearchMode.wallet:
        return 'wallet';
      case SearchMode.orders:
        return 'orders';
      case SearchMode.notifications:
        return 'notifications';
      case SearchMode.general:
        return 'general';
    }
  }
}
