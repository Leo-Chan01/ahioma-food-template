import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to monitor network connectivity status
class ConnectivityService {
  ConnectivityService() {
    _connectivity = Connectivity();
  }

  late Connectivity _connectivity;
  final _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityController.stream;

  /// Current connectivity status
  ConnectivityStatus _currentStatus = ConnectivityStatus.online;
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    try {
      // Check initial status
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);

      // Listen to connectivity changes
      _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          if (results.isNotEmpty) {
            _updateStatus(results);
          }
        },
      );
    } catch (e) {
      log('Error initializing connectivity service: $e');
      _currentStatus = ConnectivityStatus.online; // Default to online on error
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final result = results.first;

    ConnectivityStatus newStatus;

    if (result == ConnectivityResult.none) {
      newStatus = ConnectivityStatus.offline;
    } else if (result == ConnectivityResult.mobile) {
      // Consider mobile as potentially slow
      newStatus = ConnectivityStatus.slow;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet) {
      newStatus = ConnectivityStatus.online;
    } else {
      newStatus = ConnectivityStatus.slow;
    }

    if (_currentStatus != newStatus) {
      _currentStatus = newStatus;
      _connectivityController.add(newStatus);
      log('Connectivity status changed to: $newStatus');
    }
  }

  /// Dispose the service
  Future<void> dispose() async {
    await _connectivityController.close();
  }
}

/// Connectivity status enum
enum ConnectivityStatus {
  online,
  slow,
  offline,
}
