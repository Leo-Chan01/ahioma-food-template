import 'package:flutter/material.dart' show Icon, Icons;
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

/// Central repository for all app icons using HugeIcons package.
///
/// This provides easy access to HugeIcons with a consistent API.
/// Use the static methods to get HugeIcon widgets configured for your needs.
///
/// Usage:
/// ```dart
/// AppIcons.email()
/// AppIcons.password(color: Colors.blue, size: 20)
/// ```
class AppIcons {
  AppIcons._(); // Private constructor to prevent instantiation

  // Default values
  static const double _defaultSize = 24;

  // ============================================================
  // Authentication & User Icons
  // ============================================================

  /// Email icon for email input fields
  static Widget email({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedMail02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Password/Lock icon for password fields
  static Widget password({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLockPassword,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Lock icon (alternative)
  static Widget lock({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLock,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// User/Profile icon
  static Widget user({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUser,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Eye icon for showing password
  static Widget eyeShow({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedView,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Eye icon for hiding password
  static Widget eyeHide({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedViewOff,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Login icon
  static Widget login({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLogin01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Social Media Icons
  // ============================================================

  /// Facebook icon
  static Widget facebook({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedFacebook02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Google icon
  static Widget google({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedGoogle,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Apple icon
  static Widget apple({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedApple,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Twitter icon
  static Widget twitter({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTwitter,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Navigation Icons
  // ============================================================

  /// Back arrow
  static Widget arrowBack({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowLeft01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Forward arrow
  static Widget arrowForward({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowRight01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Close/Cancel icon
  static Widget close({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCancel01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Home icon
  static Widget home({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedHome01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Notification bell icon
  static Widget notification({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedNotification02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Filter icon
  static Widget filter({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedFilterHorizontal,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Action Icons
  // ============================================================

  /// Checkmark icon
  static Widget check({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTick01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Search icon
  static Widget search({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSearch01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Settings icon
  static Widget settings({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSettings01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // E-commerce Icons
  // ============================================================

  /// Shopping cart
  static Widget cart({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingCart01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Favorite/Heart
  static Widget favorite({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedFavourite,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Filled Favorite/Heart
  static Widget favoriteFilled({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedFavourite,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Star icon for ratings
  static Widget star({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedStar,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Filled star icon for ratings
  static Widget starFilled({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedStar,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Category Icons
  // ============================================================

  /// Clothes/T-shirt icon
  static Widget clothes({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTShirt,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Shoes icon
  static Widget shoes({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBasketSecure01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Bag/Handbag icon
  static Widget bag({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Electronics/Device icon
  static Widget electronics({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSmartPhone01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Watch icon
  static Widget watch({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSmartWatch01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Jewelry/Diamond icon
  static Widget jewelry({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedDiamond,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Kitchen/Utensils icon
  static Widget kitchen({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedKitchenUtensils,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Toys icon
  static Widget toys({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedToyTrain,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Store icon
  static Widget store({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedStore01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Orders icon
  static Widget orders({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Wallet icon
  static Widget wallet({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedWallet01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Profile icon
  static Widget profile({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUserCircle,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Communication Icons
  // ============================================================

  /// Chat/Message
  static Widget chat({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedMessage01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Phone
  static Widget phone({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCall,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Media Icons
  // ============================================================

  /// Image icon
  static Widget image({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedImage01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Camera icon
  static Widget camera({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCamera01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  static Widget trash({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedDelete01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  // ============================================================
  // Profile & Settings Icons
  // ============================================================

  /// Edit profile icon (person's bust)
  static Widget editProfile({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUser,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Edit/Edit icon (pencil)
  static Widget edit({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedEdit02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Location/Address icon
  static Widget location({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLocation01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Security/Shield icon
  static Widget security({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLock,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Language icon (two overlapping speech bubbles)
  static Widget language({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedMessage01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Dark mode/Eye icon
  static Widget darkMode({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedView,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Privacy/Privacy policy icon
  static Widget privacy({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLock,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Help/Information icon
  static Widget help({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSettings01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Invite friends icon (people/users)
  static Widget inviteFriends({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedUserCircle,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Logout icon
  static Widget logout({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLogout01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// More options/ellipsis vertical icon
  static Widget moreVertical({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedMoreVertical,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Arrow right icon
  static Widget arrowRight({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowRight01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Arrow down icon
  static Widget arrowDown({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowDown02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Chevron down icon
  static Widget chevronDown({Color? color, double? size}) {
    return Icon(Icons.expand_more, color: color, size: size ?? _defaultSize);
  }

  /// Arrow up icon
  static Widget arrowUp({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowUp02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Percentage icon
  static Widget percentage({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedStar,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Credit card icon
  static Widget creditCard({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedWallet01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Service/Badge icon
  static Widget service({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedSettings01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Minus icon
  static Widget minus({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowDown02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Plus icon
  static Widget plus({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowUp02,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Shopping bag icon
  static Widget shoppingBag({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Delivery truck icon
  static Widget truck({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedDeliveryTruck01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Box/Package icon
  static Widget box({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Ticket/Coupon icon
  static Widget ticket({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedTicket01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Fingerprint icon
  static Widget fingerprint({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedLock,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Calendar icon
  static Widget calendar({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCalendar01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  /// Backspace/Delete icon
  static Widget backspace({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedArrowLeft01,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  static Widget computers({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedComputer,
      color: color,
      size: size ?? _defaultSize,
    );
  }

  static Widget addition({Color? color, double? size}) {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedAdd01,
      color: color,
      size: size ?? _defaultSize,
    );
  }
}
