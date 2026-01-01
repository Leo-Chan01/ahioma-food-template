import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages guest cart session ID using SharedPreferences
/// This allows cart persistence across app restarts
class GuestCartSessionManager {
  factory GuestCartSessionManager() => _instance;

  GuestCartSessionManager._();
  static const String _sessionIdKey = 'guest_cart_session_id';
  static final GuestCartSessionManager _instance = GuestCartSessionManager._();

  /// Get or create a guest cart session ID
  /// Returns existing session ID if available, otherwise generates a new one
  Future<String> getSessionId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var sessionId = prefs.getString(_sessionIdKey);

      if (sessionId == null || sessionId.isEmpty) {
        // Generate a new session ID (UUID-like format)
        sessionId = _generateSessionId();
        await prefs.setString(_sessionIdKey, sessionId);
        if (kDebugMode) {
          debugPrint(
            '[GuestCartSessionManager] Created new session: $sessionId',
          );
        }
      }

      return sessionId;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartSessionManager] Error getting session ID: $e');
      }
      // Fallback to generating a new session ID
      return _generateSessionId();
    }
  }

  /// Clear the session ID (when user logs in or clears cart)
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionIdKey);
      if (kDebugMode) {
        debugPrint('[GuestCartSessionManager] Cleared session');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[GuestCartSessionManager] Error clearing session: $e');
      }
    }
  }

  /// Generate a simple session ID (UUID-like but simpler)
  String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return 'guest_$random';
  }
}
