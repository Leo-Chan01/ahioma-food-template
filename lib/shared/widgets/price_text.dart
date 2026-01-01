import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/price_formatter.dart';

/// A widget that displays prices with proper Naira symbol rendering.
///
/// This widget ensures the Naira symbol (₦) displays correctly on Android
/// by using a font fallback for the symbol character.
///
/// Example:
/// ```dart
/// PriceText(
///   price: 1234.56,
///   style: TextStyle(fontSize: 16),
/// )
/// ```
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDirection,
  });

  /// The price value to display
  final num price;

  /// Optional text style. If not provided, uses the default text style from theme.
  final TextStyle? style;

  /// Text alignment
  final TextAlign? textAlign;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Text direction
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    // Get the base style from theme if not provided
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    // Use the toNairaTextSpan method which handles font fallback for the symbol
    return Text.rich(
      price.toNairaTextSpan(style: baseStyle),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}
