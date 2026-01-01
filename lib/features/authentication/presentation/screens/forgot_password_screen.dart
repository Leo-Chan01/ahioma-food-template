import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';
import 'package:ahioma_food_template/core/utils/validators.dart';
import 'package:ahioma_food_template/shared/widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String path = '/forgot-password';
  static const String name = 'forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  String? _emailValidation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ({double height, double width}) screenSize = (
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
    );
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.1),
                Text('Input your email to reset your password'),
                SizedBox(height: screenSize.height * 0.02),
                AuthTextField(
                  controller: _emailController,
                  hintText: AuthStrings.emailHint,
                  onChanged: (value) {
                    setState(() {
                      _emailValidation = value.trim().validateEmail() ?? '';
                    });
                  },
                  prefixIconWidget: AppIcons.email(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                if (_emailValidation == null)
                  Text('We will send you a link to reset your password')
                else
                  Text(_emailValidation!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
