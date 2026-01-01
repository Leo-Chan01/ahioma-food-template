import 'package:flutter/material.dart';

class PinKeypadWidget extends StatelessWidget {
  const PinKeypadWidget({
    required this.onNumberPressed,
    required this.onBackspacePressed,
    super.key,
  });

  final ValueChanged<String> onNumberPressed;
  final VoidCallback onBackspacePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        children: [
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildKeypadRow(['*', '0', '']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map(_buildKeypadButton).toList(),
    );
  }

  Widget _buildKeypadButton(String value) {
    if (value == '*') {
      return _buildSpecialButton(
        icon: Icons.star,
        onTap: () => onNumberPressed(value),
      );
    }

    if (value == '') {
      return _buildSpecialButton(
        icon: Icons.arrow_back_ios_new,
        iconSize: 24,
        onTap: onBackspacePressed,
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onNumberPressed(value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton({
    required IconData icon,
    required VoidCallback onTap,
    double iconSize = 32,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

