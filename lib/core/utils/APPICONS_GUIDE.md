# AppIcons Utility Guide

A centralized utility for accessing HugeIcons throughout your app.

## ✨ What It Does

The `AppIcons` class provides easy access to HugeIcons with a consistent, type-safe API. Instead of importing HugeIcons everywhere and remembering icon names, use `AppIcons` for quick access to commonly used icons.

## 🚀 Usage

### Basic Usage

```dart
import 'package:ahioma_food_template/core/utils/app_icons.dart';

// Use directly as a widget
AppIcons.email()
AppIcons.password()
AppIcons.facebook()
```

### With Customization

```dart
// Customize color and size
AppIcons.email(
  color: Colors.blue,
  size: 20,
)

// In a widget
IconButton(
  icon: AppIcons.search(
    color: theme.colorScheme.primary,
  ),
  onPressed: () {},
)
```

### In Your Auth Widgets

All auth widgets have been updated to use `AppIcons`:

```dart
// Social login buttons use HugeIcons
SocialLoginButtons.facebook(onPressed: () {})
SocialLoginButtons.google(onPressed: () {})
SocialLoginButtons.apple(onPressed: () {})

// Password field uses HugeIcons for toggle
AuthTextField(
  prefixIconWidget: AppIcons.password(
    color: theme.colorScheme.onSurfaceVariant,
  ),
  enablePasswordToggle: true, // Uses HugeIcons eyeShow/eyeHide
)

// Back button
IconButton(
  icon: AppIcons.arrowBack(),
  onPressed: () => Navigator.pop(context),
)
```

## 📖 Available Icon Categories

### Authentication & User
- `AppIcons.email()` - Mail icon for email fields
- `AppIcons.password()` - Lock icon for password fields
- `AppIcons.lock()` - Alternative lock icon
- `AppIcons.user()` - User profile icon
- `AppIcons.eyeShow()` - Show password icon
- `AppIcons.eyeHide()` - Hide password icon
- `AppIcons.login()` - Login icon

### Social Media
- `AppIcons.facebook()` - Facebook icon
- `AppIcons.google()` - Google icon
- `AppIcons.apple()` - Apple icon
- `AppIcons.twitter()` - Twitter icon

### Navigation
- `AppIcons.arrowBack()` - Back arrow
- `AppIcons.arrowForward()` - Forward arrow
- `AppIcons.close()` - Close/Cancel icon
- `AppIcons.home()` - Home icon

### Actions
- `AppIcons.check()` - Checkmark
- `AppIcons.search()` - Search icon
- `AppIcons.settings()` - Settings icon

### E-commerce
- `AppIcons.cart()` - Shopping cart
- `AppIcons.favorite()` - Heart/favorite icon
- `AppIcons.store()` - Store icon

### Communication
- `AppIcons.chat()` - Chat/message icon
- `AppIcons.phone()` - Phone icon

### Media
- `AppIcons.image()` - Image icon
- `AppIcons.camera()` - Camera icon

## 🎨 Why Use AppIcons?

### ✅ Benefits

1. **Consistent Icons** - All icons come from the same HugeIcons package
2. **Easy to Change** - Update an icon once, it changes everywhere
3. **Type Safety** - IDE autocomplete helps you find icons
4. **Cleaner Code** - No need to import HugeIcons everywhere
5. **Customizable** - Color and size parameters on every icon
6. **Theme-Aware** - Pass theme colors for consistent styling

### ❌ Without AppIcons

```dart
import 'package:hugeicons/hugeicons.dart';

// Hard to remember exact icon names
HugeIcon(
  icon: HugeIcons.strokeRoundedMail02,
  color: theme.colorScheme.onSurfaceVariant,
  size: 24,
)
```

### ✅ With AppIcons

```dart
import 'package:ahioma_food_template/core/utils/app_icons.dart';

// Clean and simple
AppIcons.email(
  color: theme.colorScheme.onSurfaceVariant,
  size: 24,
)
```

## 🔧 Adding More Icons

To add more icons to `AppIcons`:

1. Open `lib/core/utils/app_icons.dart`
2. Add a new static method:

```dart
/// Your icon description
static Widget yourIcon({
  Color? color,
  double? size,
}) {
  return HugeIcon(
    icon: HugeIcons.strokeRoundedYourIcon,
    color: color,
    size: size ?? _defaultSize,
  );
}
```

3. Use it anywhere: `AppIcons.yourIcon()`

## 📚 Examples

### In a Form

```dart
AuthTextField(
  prefixIconWidget: AppIcons.email(
    color: theme.colorScheme.onSurfaceVariant,
  ),
  hintText: 'Email',
)
```

### In an AppBar

```dart
AppBar(
  leading: IconButton(
    icon: AppIcons.arrowBack(),
    onPressed: () => Navigator.pop(context),
  ),
  actions: [
    IconButton(
      icon: AppIcons.search(),
      onPressed: () {},
    ),
    IconButton(
      icon: AppIcons.settings(),
      onPressed: () {},
    ),
  ],
)
```

### In a Button

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: AppIcons.cart(size: 20),
  label: Text('Add to Cart'),
)
```

### In Navigation

```dart
BottomNavigationBarItem(
  icon: AppIcons.home(),
  activeIcon: AppIcons.home(
    color: theme.colorScheme.primary,
  ),
  label: 'Home',
)
```

## 💡 Pro Tips

1. **Always pass theme colors** for consistency:
   ```dart
   AppIcons.email(color: theme.colorScheme.onSurfaceVariant)
   ```

2. **Use Builder for theme access** when needed:
   ```dart
   Builder(
     builder: (context) {
       final theme = Theme.of(context);
       return AppIcons.email(color: theme.colorScheme.primary);
     },
   )
   ```

3. **Size icons appropriately**:
   - Form fields: 20-24px
   - AppBar: 24px (default)
   - Large buttons: 28-32px
   - Illustrations: 60-80px

4. **Check the source** - `lib/core/utils/app_icons.dart` has all available icons

## 🎉 You're All Set!

All your auth screens and widgets now use HugeIcons through the `AppIcons` utility. Enjoy consistent, beautiful icons throughout your app!
