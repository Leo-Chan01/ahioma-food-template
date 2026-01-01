import 'package:flutter/services.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';

Future<void> copyThisToClipBoard(String trim) async {
  await Clipboard.setData(ClipboardData(text: trim));
  GlobalSnackBar.showSuccess(
    'Copied to Clipboard',
  );
}
