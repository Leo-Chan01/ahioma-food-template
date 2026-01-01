import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/onboarding_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/fill_your_profile_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/set_your_fingerprint_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/widgets/pin_input_fields_widget.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/widgets/pin_keypad_widget.dart';
import 'package:provider/provider.dart';

class CreateNewPinScreen extends StatefulWidget {
  const CreateNewPinScreen({super.key});

  static const String path = '/onboarding/create-pin';
  static const String name = 'create-pin';

  @override
  State<CreateNewPinScreen> createState() => _CreateNewPinScreenState();
}

class _CreateNewPinScreenState extends State<CreateNewPinScreen> {
  static const int _pinLength = 4;
  String _pin = '';
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AccountSetupProvider>();
      if (!provider.hasCredentials) {
        context.goNamed(SignUpScreen.name);
        return;
      }
      if (!provider.isProfileStepComplete) {
        context.goNamed(FillYourProfileScreen.name);
        return;
      }
      final existingPin = provider.pin;
      if (existingPin != null && existingPin.length <= _pinLength) {
        setState(() {
          _pin = existingPin;
          _focusedIndex = existingPin.length;
        });
      }
    });
  }

  void _onNumberPressed(String value) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += value;
        _focusedIndex = _pin.length;
      });

      if (_pin.length == _pinLength) {
        // PIN is complete, save to provider and proceed to next screen
        context.read<AccountSetupProvider>().updatePin(_pin);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            unawaited(context.pushNamed(SetYourFingerprintScreen.name));
          }
        });
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _focusedIndex = _pin.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          OnboardingStrings.createNewPIN,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Instruction Text
                  Text(
                    OnboardingStrings.addPINInstruction,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // PIN Input Fields
                  PinInputFieldsWidget(
                    pinLength: _pinLength,
                    onFieldTapped: (index) {},
                    focusedIndex: _focusedIndex,
                    pin: _pin,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          // Keypad
          PinKeypadWidget(
            onNumberPressed: _onNumberPressed,
            onBackspacePressed: _onBackspacePressed,
          ),
        ],
      ),
    );
  }
}
