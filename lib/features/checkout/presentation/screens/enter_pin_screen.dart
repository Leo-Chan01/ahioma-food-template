import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  static const String path = '/enter-pin';
  static const String name = 'enter-pin';

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final List<String> _pinDigits = ['', '', '', ''];
  int _currentIndex = 0;

  void _addDigit(String digit) {
    if (_currentIndex < 4) {
      setState(() {
        _pinDigits[_currentIndex] = digit;
        _currentIndex++;
      });

      // Auto proceed when PIN is complete
      if (_currentIndex == 4) {
        Future.delayed(const Duration(milliseconds: 300), () {
          // Return true to indicate PIN was entered successfully
          Navigator.of(context).pop(true);
        });
      }
    }
  }

  void _removeDigit() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pinDigits[_currentIndex] = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.enterYourPin,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CheckoutStrings.enterPinToConfirmPayment,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    final isFilled = _pinDigits[index].isNotEmpty;
                    final isActive = _currentIndex == index;
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: theme.colorScheme.surface,
                      ),
                      child: Center(
                        child: isFilled
                            ? _currentIndex > index || !isActive
                                  ? Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : Text(
                                      _pinDigits[index],
                                      style: theme.textTheme.headlineSmall,
                                    )
                            : null,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _currentIndex == 4
                        ? () => Navigator.of(context).pop(true)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      CheckoutStrings.continueText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Numeric Keypad
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    '1',
                    '2',
                    '3',
                  ].map((digit) => _buildKeypadButton(digit, theme)).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    '4',
                    '5',
                    '6',
                  ].map((digit) => _buildKeypadButton(digit, theme)).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    '7',
                    '8',
                    '9',
                  ].map((digit) => _buildKeypadButton(digit, theme)).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildKeypadButton('*', theme),
                    _buildKeypadButton('0', theme),
                    _buildDeleteButton(theme),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String digit, ThemeData theme) {
    return InkWell(
      onTap: () => _addDigit(digit),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: Text(
          digit,
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(ThemeData theme) {
    return InkWell(
      onTap: _removeDigit,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: AppIcons.arrowBack(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
