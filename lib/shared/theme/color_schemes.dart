import 'package:flutter/material.dart';

/// Ash & Black Color Schemes
///
/// This color scheme uses various shades of ash (gray) and black
/// to create a monochromatic, sophisticated look.
///
/// Light Theme: Light ash backgrounds with dark ash/black text
/// Dark Theme: Black/dark ash backgrounds with light ash text
///
/// Primary accent: A subtle gray-blue that complements the ash palette

class AppColorSchemes {
  // Light Theme - Light Ash & Black
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary: Medium-dark ash with slight blue tint
    primary: Color(0xFF5A6470), // Dark ash blue
    onPrimary: Color(0xFFFFFFFF), // White for contrast
    primaryContainer: Color(0xFF8A95A5), // Lighter ash blue
    onPrimaryContainer: Color(0xFF2C3238), // Very dark ash
    // Secondary: Pure ash tones
    secondary: Color(0xFF787C82), // Medium ash
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD1D3D7), // Light ash
    onSecondaryContainer: Color(0xFF3A3D42), // Dark ash
    // Tertiary: Slightly warm ash
    tertiary: Color(0xFF6D6E71), // Warm ash
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFCACBCD), // Light warm ash
    onTertiaryContainer: Color(0xFF38393B), // Dark warm ash
    // Error: Muted red that works with ash
    error: Color(0xFFC53E3E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFD7D7),
    onErrorContainer: Color(0xFF8C2828),
    // Surface: Light ash background
    surface: Color(0xFFF8F9FA), // Very light ash
    onSurface: Color(0xFF1C1C1E), // Almost black
    surfaceContainerHighest: Color(0xFFECEDEF), // Light ash
    onSurfaceVariant: Color(0xFF4B4B4D), // Medium dark ash
    // Outlines and borders
    outline: Color(0xFFB8BABD), // Medium light ash
    outlineVariant: Color(0xFFDCDDDF), // Very light ash
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF1C1C1E), // Almost black
    onInverseSurface: Color(0xFFF5F5F7), // Light ash
    inversePrimary: Color(0xFF9BA5B3), // Light ash blue
    surfaceTint: Color(0xFF5A6470),
  );

  // Dark Theme - Black & Dark Ash
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary: Lighter ash blue for dark mode
    primary: Color(0xFF9BA5B3), // Light ash blue
    onPrimary: Color(0xFF2C3238), // Very dark ash
    primaryContainer: Color(0xFF485461), // Medium dark ash blue
    onPrimaryContainer: Color(0xFFE8EAED), // Very light ash
    // Secondary: Light ash tones
    secondary: Color(0xFFA8ACB0), // Light ash
    onSecondary: Color(0xFF2A2C30), // Very dark ash
    secondaryContainer: Color(0xFF525659), // Medium dark ash
    onSecondaryContainer: Color(0xFFDEE0E2), // Very light ash
    // Tertiary: Light warm ash
    tertiary: Color(0xFFAFB0B3), // Light warm ash
    onTertiary: Color(0xFF2E2F31), // Very dark warm ash
    tertiaryContainer: Color(0xFF5B5C5E), // Medium dark warm ash
    onTertiaryContainer: Color(0xFFE0E1E2), // Very light warm ash
    // Error: Brighter red for dark mode
    error: Color(0xFFEF5350),
    onError: Color(0xFF1C1C1E),
    errorContainer: Color(0xFF8C2828),
    onErrorContainer: Color(0xFFFFD7D7),
    // Surface: Pure black to dark ash
    surface: Color(0xFF000000), // Pure black
    onSurface: Color(0xFFE8EAED), // Very light ash
    surfaceContainerHighest: Color(0xFF1C1C1E), // Very dark ash
    onSurfaceVariant: Color(0xFFB8BABD), // Medium light ash
    // Outlines and borders
    outline: Color(0xFF4B4B4D), // Medium dark ash
    outlineVariant: Color(0xFF2A2A2C), // Very dark ash
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE8EAED), // Very light ash
    onInverseSurface: Color(0xFF1C1C1E), // Very dark ash
    inversePrimary: Color(0xFF5A6470), // Dark ash blue
    surfaceTint: Color(0xFF9BA5B3),
  );

  // Custom status colors that complement the ash & black theme
  static const Color success = Color(0xFF5C8A5A); // Muted green
  static const Color error = Color(0xFFC53E3E); // Muted red
  static const Color warning = Color(0xFFD4A04C); // Muted amber
  static const Color info = Color(0xFF5A7A9B); // Muted blue

  // Surface variants for input fields and elevated surfaces
  static const Color lightSurfaceVariant = Color(0xFFECEDEF); // Light ash
  static const Color darkSurfaceVariant = Color(0xFF1C1C1E); // Very dark ash
}
