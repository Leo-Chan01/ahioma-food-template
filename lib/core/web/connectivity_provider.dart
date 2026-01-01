import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/web/connectivity_service.dart';

/// Provider for managing connectivity status across the app
class ConnectivityProvider extends ChangeNotifier {
  ConnectivityProvider(this._connectivityService) {
    _initialize();
  }

  final ConnectivityService _connectivityService;
  ConnectivityStatus _status = ConnectivityStatus.online;
  StreamSubscription<ConnectivityStatus>? _subscription;

  /// Current connectivity status
  ConnectivityStatus get status => _status;

  /// Check if connected
  bool get isConnected => _status != ConnectivityStatus.offline;

  /// Check if slow connection
  bool get isSlowConnection => _status == ConnectivityStatus.slow;

  /// Check if offline
  bool get isOffline => _status == ConnectivityStatus.offline;

  void _initialize() {
    unawaited(_connectivityService.initialize());
    _status = _connectivityService.currentStatus;

    // Listen to connectivity changes
    _subscription = _connectivityService.connectivityStream.listen((status) {
      _status = status;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    //
    // ignore: discarded_futures
    _subscription?.cancel();
    super.dispose();
  }
}
