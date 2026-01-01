import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Extension on [BuildContext] for convenient navigation.
///
/// This extension provides easy access to go_router navigation methods
/// while following Clean Architecture principles by keeping navigation
/// logic separate from business logic.
extension AppNavigation on BuildContext {
  /// Navigate to a new route by path
  void goTo(String path) => go(path);

  /// Navigate to a new route by path and return when the new route is popped
  Future<T?> pushTo<T extends Object?>(String path) => push<T>(path);

  /// Replace the current route
  void replaceTo(String path) => pushReplacement(path);

  /// Pop the current route
  void goBack() => pop();

  /// Pop until reaching the specified route
  void popUntil(String path) => go(path);

  /// Check if we can pop the current route
  bool get canGoBack => canPop();

  /// Get the current route path
  String get currentPath => GoRouterState.of(this).uri.path;

  /// Get route parameters
  Map<String, String> get pathParameters =>
      GoRouterState.of(this).pathParameters;

  /// Get query parameters
  Map<String, String> get queryParameters =>
      GoRouterState.of(this).uri.queryParameters;
}
