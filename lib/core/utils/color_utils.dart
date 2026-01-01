import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utility functions for working with colors
class ColorUtils {
  ColorUtils._();

  /// Calculate the relative luminance of a color (0 = darkest, 1 = lightest)
  /// Uses the WCAG formula: https://www.w3.org/WAI/GL/wiki/Relative_luminance
  static double _getLuminance(Color color) {
    final rsRGB = color.red / 255.0;
    final gsRGB = color.green / 255.0;
    final bsRGB = color.blue / 255.0;

    final r = rsRGB <= 0.03928
        ? rsRGB / 12.92
        : math.pow((rsRGB + 0.055) / 1.055, 2.4).toDouble();
    final g = gsRGB <= 0.03928
        ? gsRGB / 12.92
        : math.pow((gsRGB + 0.055) / 1.055, 2.4).toDouble();
    final b = bsRGB <= 0.03928
        ? bsRGB / 12.92
        : math.pow((bsRGB + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Calculate contrast ratio between two colors
  /// WCAG AA requires at least 4.5:1 for normal text and 3:1 for large text
  static double getContrastRatio(Color color1, Color color2) {
    final lum1 = _getLuminance(color1);
    final lum2 = _getLuminance(color2);

    final lighter = lum1 > lum2 ? lum1 : lum2;
    final darker = lum1 > lum2 ? lum2 : lum1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Get the appropriate text color (black or white) for a given background color
  /// Uses luminance to determine which provides better contrast
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = _getLuminance(backgroundColor);
    // If background is dark (luminance < 0.5), use white text
    // If background is light (luminance >= 0.5), use black text
    return luminance < 0.5 ? Colors.white : Colors.black;
  }

  /// Parse hex color string to Color object
  /// Supports formats: #RGB, #RRGGBB, #AARRGGBB
  static Color parseHexColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ColorExtension on Color {
  /// Get the appropriate text color for this background color
  Color get textColor => ColorUtils.getTextColorForBackground(this);

  /// Check if this color is dark
  bool get isDark => ColorUtils._getLuminance(this) < 0.5;

  /// Check if this color is light
  bool get isLight => ColorUtils._getLuminance(this) >= 0.5;
}
