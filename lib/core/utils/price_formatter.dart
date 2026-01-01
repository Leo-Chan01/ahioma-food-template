import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension for formatting prices in Naira currency
extension PriceFormatter on num {
  /// Formats the number as Naira currency with proper comma and dot separation
  ///
  /// Example:
  /// - 1000.toNaira() returns "₦1,000.00"
  /// - 12345.67.toNaira() returns "₦12,345.67"
  /// - 1234567.89.toNaira() returns "₦1,234,567.89"
  String toNaira() {
    final formatter = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
      locale: 'en_NG',
    );
    return formatter.format(this);
  }

  /// Returns a TextSpan with proper font fallback for the Naira symbol.
  /// 
  /// This is useful for displaying prices in Text.rich widgets to ensure
  /// the Naira symbol renders correctly on Android devices.
  /// 
  /// Example:
  /// ```dart
  /// Text.rich(
  ///   1234.56.toNairaTextSpan(style: TextStyle(fontSize: 16)),
  /// )
  /// ```
  TextSpan toNairaTextSpan({TextStyle? style}) {
    final formattedPrice = toNaira();
    const nairaSymbol = '₦';
    final hasSymbol = formattedPrice.startsWith(nairaSymbol);
    final numberPart = hasSymbol 
        ? formattedPrice.substring(1) 
        : formattedPrice;

    return TextSpan(
      children: [
        if (hasSymbol)
          TextSpan(
            text: nairaSymbol,
            // Use font fallback that supports Naira symbol on Android
            style: style?.copyWith(
              fontFamilyFallback: const ['Roboto', 'Noto Sans', 'sans-serif'],
            ) ?? const TextStyle(
              fontFamilyFallback: ['Roboto', 'Noto Sans', 'sans-serif'],
            ),
          ),
        TextSpan(
          text: numberPart,
          style: style,
        ),
      ],
    );
  }
}

/// Extension for formatting string prices in Naira currency
extension StringPriceFormatter on String {
  /// Formats the string as Naira currency with proper comma and dot separation
  ///
  /// Attempts to parse the string to a number first.
  /// Returns "₦0.00" if parsing fails.
  ///
  /// Example:
  /// - "1000".toNaira() returns "₦1,000.00"
  /// - "12345.67".toNaira() returns "₦12,345.67"
  String toNaira() {
    final value = num.tryParse(this);
    if (value == null) return '₦0.00';
    return value.toNaira();
  }

  /// Returns a TextSpan with proper font fallback for the Naira symbol.
  /// 
  /// This is useful for displaying prices in Text.rich widgets to ensure
  /// the Naira symbol renders correctly on Android devices.
  TextSpan toNairaTextSpan({TextStyle? style}) {
    final value = num.tryParse(this);
    if (value == null) {
      return TextSpan(
        children: [
          TextSpan(
            text: '₦',
            style: style?.copyWith(
              fontFamilyFallback: const ['Roboto', 'Noto Sans', 'sans-serif'],
            ) ?? const TextStyle(
              fontFamilyFallback: ['Roboto', 'Noto Sans', 'sans-serif'],
            ),
          ),
          TextSpan(text: '0.00', style: style),
        ],
      );
    }
    return value.toNairaTextSpan(style: style);
  }

  /// Formats the string as NGN currency with proper comma and dot separation
  ///
  /// Attempts to parse the string to a number first.
  /// Returns "NGN 0.00" if parsing fails.
  ///
  /// Example:
  /// - "1000".toNGN() returns "NGN 1,000.00"
  /// - "12345.67".toNGN() returns "NGN 12,345.67"
  String toNGN() {
    final value = num.tryParse(this);
    if (value == null) return 'NGN 0.00';
    return value.toNGN();
  }
}

/// Extension for formatting numbers as NGN currency
extension NumNGNFormatter on num {
  /// Formats the number as NGN currency with proper comma and dot separation
  ///
  /// Example:
  /// - 1000.toNGN() returns "NGN 1,000.00"
  /// - 12345.67.toNGN() returns "NGN 12,345.67"
  /// - 1234567.89.toNGN() returns "NGN 1,234,567.89"
  String toNGN() {
    final formatter = NumberFormat.currency(
      symbol: 'NGN ',
      decimalDigits: 2,
      locale: 'en_NG',
    );
    return formatter.format(this);
  }
}
