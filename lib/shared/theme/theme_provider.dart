import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadThemeFromPreferences();
  }

  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  bool get isLightMode => _themeMode == AppThemeMode.light;
  bool get isDarkMode => _themeMode == AppThemeMode.dark;
  bool get isSystemMode => _themeMode == AppThemeMode.system;

  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = sl<SharedPreferences>();
      final themeModeString = prefs.getString(AppConstants.themeKey);
      if (themeModeString != null) {
        _themeMode = _parseThemeMode(themeModeString);
        _updateSystemUIOverlay();
        notifyListeners();
      }
    } catch (e) {
      // If SharedPreferences is not available or error occurs, use default
    }
  }

  AppThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  Future<void> _saveThemeToPreferences(AppThemeMode themeMode) async {
    try {
      final prefs = sl<SharedPreferences>();
      await prefs.setString(
        AppConstants.themeKey,
        _themeModeToString(themeMode),
      );
    } catch (e) {
      // Silently handle errors when saving preference
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    _themeMode = themeMode;
    _updateSystemUIOverlay();
    await _saveThemeToPreferences(themeMode);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }

  bool isDark(BuildContext context) {
    if (_themeMode == AppThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == AppThemeMode.dark;
  }

  void _updateSystemUIOverlay() {
    if (_themeMode == AppThemeMode.light) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    } else if (_themeMode == AppThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFF121212),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }
  }
}
