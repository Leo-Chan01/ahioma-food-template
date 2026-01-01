import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/notification_settings_option_widget.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  static const String path = '/profile/notification-settings';
  static const String name = 'notification-settings';

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _generalNotification = true;
  bool _sound = true;
  bool _vibrate = false;
  bool _specialOffers = true;
  bool _promoDiscount = false;
  bool _payments = true;
  bool _cashback = false;
  bool _appUpdates = true;
  bool _newServiceAvailable = false;
  bool _newTipsAvailable = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          ProfileStrings.notification,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NotificationSettingsOptionWidget(
              title: ProfileStrings.generalNotification,
              value: _generalNotification,
              onChanged: (value) {
                setState(() {
                  _generalNotification = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.sound,
              value: _sound,
              onChanged: (value) {
                setState(() {
                  _sound = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.vibrate,
              value: _vibrate,
              onChanged: (value) {
                setState(() {
                  _vibrate = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.specialOffers,
              value: _specialOffers,
              onChanged: (value) {
                setState(() {
                  _specialOffers = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.promoDiscount,
              value: _promoDiscount,
              onChanged: (value) {
                setState(() {
                  _promoDiscount = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.payments,
              value: _payments,
              onChanged: (value) {
                setState(() {
                  _payments = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.cashback,
              value: _cashback,
              onChanged: (value) {
                setState(() {
                  _cashback = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.appUpdates,
              value: _appUpdates,
              onChanged: (value) {
                setState(() {
                  _appUpdates = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.newServiceAvailable,
              value: _newServiceAvailable,
              onChanged: (value) {
                setState(() {
                  _newServiceAvailable = value;
                });
              },
            ),
            NotificationSettingsOptionWidget(
              title: ProfileStrings.newTipsAvailable,
              value: _newTipsAvailable,
              onChanged: (value) {
                setState(() {
                  _newTipsAvailable = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
