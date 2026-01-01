import 'dart:convert';
import 'package:flutter/widgets.dart';

Image? decodeBase64Image(String? base64String) {
  if (base64String == null || base64String.isEmpty) return null;
  try {
    final bytes = base64Decode(base64String.split(',').last);
    return Image.memory(bytes);
  } catch (e) {
    return null;
  }
}
