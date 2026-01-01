import 'package:flutter/material.dart';

class CongratulationsModalWidget extends StatelessWidget {
  const CongratulationsModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            _buildIllustration(context),
            const SizedBox(height: 24),
            // Title
            Text(
              'Congratulations!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              'Your account is ready to use. You will be redirected to the Home page in a few seconds..',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Loading Indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Central person icon
          Icon(
            Icons.person,
            size: 60,
            color: colorScheme.onSurfaceVariant,
          ),
          // Abstract dots around the circle
          ...List.generate(8, (index) {
            final angle = (index * 2 * 3.14159) / 8;
            const radius = 50.0;
            final x = radius * (1 + 0.3 * (index % 3 + 1) / 3) * cos(angle);
            final y = radius * (1 + 0.3 * (index % 3 + 1) / 3) * sin(angle);

            return Positioned(
              left: 60 + x,
              top: 60 + y,
              child: Container(
                width: (8 - index % 4).toDouble(),
                height: (8 - index % 4).toDouble(),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  double cos(double radians) {
    // Approximate cosine values for simple cases
    if (radians == 0) return 1;
    if ((radians - 3.14159).abs() < 0.001) return -1;
    if ((radians - 3.14159 / 2).abs() < 0.1) return 0;
    // Simple approximation
    return -1 + 2 * (radians / 3.14159);
  }

  double sin(double radians) {
    // Approximate sine values
    if ((radians - 3.14159 / 2).abs() < 0.1) return 1;
    if ((radians - 3 * 3.14159 / 2).abs() < 0.1) return -1;
    if (radians == 0 || (radians - 3.14159).abs() < 0.001) return 0;
    return 1 - 2 * (radians / 3.14159);
  }
}

