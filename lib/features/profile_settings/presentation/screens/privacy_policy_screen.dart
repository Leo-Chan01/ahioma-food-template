import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String path = '/profile/privacy-policy';
  static const String name = 'privacy-policy';

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
          ProfileStrings.privacyPolicy,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1
            Text(
              ProfileStrings.typesOfDataWeCollect,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            // Section 2
            Text(
              ProfileStrings.useOfPersonalData,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Magna etiam tempor orci eu lobortis elementum nibh tellus. Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque. Eget dolor morbi non arcu risus quis varius quam.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Quisque egestas diam in arcu cursus euismod. Dictumst quisque sagittis purus sit amet volutpat consequat mauris. Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'At augue eget arcu dictum varius. Nunc mattis enim ut tellus elementum sagittis vitae et leo. Est placerat in egestas erat imperdiet sed euismod nisi porta.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            // Section 3
            Text(
              ProfileStrings.disclosureOfPersonalData,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Consequat id porta nibh venenatis cras. Felis bibendum ut tristique et egestas quis ipsum suspendisse. Sed velit dignissim sodales ut eu sem integer vitae.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Turpis egestas pretium aenean pharetra magna ac placerat. Imperdiet sed euismod nisi porta lorem mollis aliquam. Porttitor lacus luctus accumsan tortor posuere.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Ut sem nulla pharetra diam sit amet nisl suscipit. Bibendum at varius vel pharetra vel turpis. Erat pellentesque adipiscing commodo elit at imperdiet dui accumsan.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Sit amet nulla facilisi morbi tempus iaculis urna id. Aenean sed adipiscing diam donec adipiscing tristique. Mi sit amet mauris commodo quis imperdiet massa tincidunt.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
