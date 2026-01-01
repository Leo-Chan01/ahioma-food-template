import 'package:ahioma_food_template/core/utils/strings/auth_strings.dart';

extension Validators on String {
  String? validateEmail() {
    if (isEmpty) return AuthStrings.emailRequired;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this)) {
      return AuthStrings.emailInvalid;
    }
    return null;
  }
}
