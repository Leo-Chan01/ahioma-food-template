// ignore_for_file: discarded_futures

import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/strings/common_strings.dart';
import 'package:ahioma_food_template/core/web/connectivity_service.dart';

/// Overlay widget that shows when network connectivity is poor
class ConnectivityOverlay extends StatefulWidget {
  const ConnectivityOverlay({
    required this.child,
    required this.connectivityStatus,
    super.key,
  });

  final Widget child;
  final ConnectivityStatus connectivityStatus;

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(
        parent: _blinkController,
        curve: Curves.easeInOut,
      ),
    );

    _blinkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = widget.connectivityStatus == ConnectivityStatus.offline;
    // final isSlow = widget.connectivityStatus == ConnectivityStatus.slow;

    return Stack(
      textDirection: TextDirection.ltr,
      children: [
        widget.child,
        // Full-page overlay for offline
        if (isOffline)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: AnimatedBuilder(
                  animation: _blinkAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _blinkAnimation.value,
                      child: child,
                    );
                  },
                  child: _buildOfflineOverlay(context),
                ),
              ),
            ),
          ),
        // Top snackbar for slow connection
        // if (isSlow)
        //   Positioned(
        //     top: 0,
        //     left: 0,
        //     right: 0,
        //     child: AnimatedBuilder(
        //       animation: _blinkAnimation,
        //       builder: (context, child) {
        //         return Opacity(
        //           opacity: _blinkAnimation.value,
        //           child: child,
        //         );
        //       },
        //       child: _buildSlowConnectionBanner(context),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildOfflineOverlay(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Blinking Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),

                // Warning Text
                Text(
                  CommonStrings.noInternetConnectionTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  CommonStrings.noInternetDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Retry Button
                ElevatedButton.icon(
                  onPressed: () {
                    // The connectivity service will automatically update
                    // when connection is restored
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text(CommonStrings.checking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildSlowConnectionBanner(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.signal_wifi_bad_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      CommonStrings.slowConnection,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
