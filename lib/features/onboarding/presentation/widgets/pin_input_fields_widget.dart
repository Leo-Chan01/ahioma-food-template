import 'package:flutter/material.dart';

class PinInputFieldsWidget extends StatelessWidget {
  const PinInputFieldsWidget({
    required this.pinLength,
    required this.onFieldTapped,
    required this.focusedIndex,
    required this.pin,
    super.key,
  });

  final int pinLength;
  final ValueChanged<int> onFieldTapped;
  final int focusedIndex;
  final String pin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pinLength,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildPinField(
            context: context,
            isFocused: index == focusedIndex,
            hasValue: index < pin.length,
          ),
        ),
      ),
    );
  }

  Widget _buildPinField({
    required BuildContext context,
    required bool isFocused,
    required bool hasValue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: hasValue ? colorScheme.onSurface : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFocused
              ? colorScheme.primary
              : colorScheme.outlineVariant,
          width: isFocused ? 2 : 1,
        ),
      ),
      child: hasValue
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

