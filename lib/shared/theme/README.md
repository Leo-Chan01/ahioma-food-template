# Ahioma E-Commerce ahioma_food_template - Theming System

A comprehensive theming system with light and dark mode support for the Ahioma Multi-Tenant Flutter application.

## Features

- ✅ **Material 3 Design System** compliance
- ✅ **Light & Dark Theme** support
- ✅ **System Theme Detection** 
- ✅ **Provider State Management** for theme switching
- ✅ **Comprehensive Component Styling**
- ✅ **Theme Toggle Widget** for easy switching
- ✅ **Custom Color Schemes** ready for customization

## File Structure

```
lib/theme/
├── theme.dart                      # Main export file
├── app_theme.dart                  # Complete theme configurations
├── color_schemes.dart              # Light/dark color schemes
├── text_theme.dart                 # Typography definitions
├── theme_provider.dart             # State management for themes
└── widgets/
    └── theme_toggle_button.dart    # Theme switching widget
```

## Usage

### 1. Theme Provider Setup

The `ThemeProvider` is automatically set up in the main app. It provides:

- `AppThemeMode.light` - Force light theme
- `AppThemeMode.dark` - Force dark theme  
- `AppThemeMode.system` - Follow system settings

### 2. Accessing Theme in Widgets

```dart
// Get current theme data
final theme = Theme.of(context);

// Check if dark mode is active
final themeProvider = context.watch<ThemeProvider>();
final isDark = themeProvider.isDark(context);

// Toggle theme
context.read<ThemeProvider>().toggleTheme();

// Set specific theme
context.read<ThemeProvider>().setThemeMode(AppThemeMode.dark);
```

### 3. Using Theme Toggle Button

```dart
AppBar(
  title: Text('My App'),
  actions: [
    ThemeToggleButton(), // Provides dropdown to switch themes
  ],
)
```

### 4. Accessing Colors

```dart
// Material 3 semantic colors
final primary = Theme.of(context).colorScheme.primary;
final surface = Theme.of(context).colorScheme.surface;
final onSurface = Theme.of(context).colorScheme.onSurface;

// Custom colors
final success = AppColorSchemes.success;
final warning = AppColorSchemes.warning;
```

### 5. Using Typography

```dart
Text(
  'Display Large',
  style: Theme.of(context).textTheme.displayLarge,
)

Text(
  'Body Text',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

## Customization

### Colors

Update colors in `lib/theme/color_schemes.dart`:

```dart
// Example: Change primary color
static const ColorScheme lightColorScheme = ColorScheme(
  primary: Color(0xFF007AFF), // Your brand blue
  // ... other colors
);
```

### Typography

Modify text styles in `lib/theme/text_theme.dart`:

```dart
// Example: Change font family
static const String _fontFamily = 'YourCustomFont';
```

### Component Themes

Customize individual components in `lib/theme/app_theme.dart`:

```dart
// Example: Customize button themes
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: yourCustomColor,
    // ... other properties
  ),
),
```

## Components Themed

- ✅ AppBar
- ✅ Cards
- ✅ Buttons (Elevated, Outlined, Text)
- ✅ Input Fields
- ✅ FloatingActionButton
- ✅ Bottom Navigation
- ✅ Drawer
- ✅ Dividers
- ✅ Chips
- ✅ System UI (Status bar, Navigation bar)

## Theme Testing

All themes are automatically tested in the widget tests. The test helper `PumpApp` includes theme setup to ensure consistent testing across light and dark modes.

## Best Practices

1. **Always use semantic colors** from `Theme.of(context).colorScheme`
2. **Use text styles** from `Theme.of(context).textTheme`
3. **Test in both light and dark modes**
4. **Provide theme toggle** for user preference
5. **Follow Material 3 guidelines** for consistency

## Future Enhancements

- [ ] Add color seed generation from brand colors
- [ ] Add theme persistence (SharedPreferences)
- [ ] Add custom color tokens for sports betting specific UI
- [ ] Add theme animations and transitions
- [ ] Add high contrast mode support

---

## Quick Start

1. The theming system is already set up and working
2. Use the theme toggle button to switch between modes
3. Customize colors in `color_schemes.dart` to match your brand
4. All components will automatically adapt to your color choices
