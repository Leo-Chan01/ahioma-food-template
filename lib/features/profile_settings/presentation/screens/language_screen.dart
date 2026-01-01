import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  static const String path = '/profile/language';
  static const String name = 'language';

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = ProfileStrings.englishUS;

  final List<String> _suggestedLanguages = [
    ProfileStrings.englishUS,
    ProfileStrings.englishUK,
  ];

  final List<String> _allLanguages = [
    ProfileStrings.mandarin,
    ProfileStrings.hindi,
    ProfileStrings.spanish,
    ProfileStrings.french,
    ProfileStrings.arabic,
    ProfileStrings.bengali,
    ProfileStrings.russian,
    ProfileStrings.indonesia,
  ];

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
          ProfileStrings.language,
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
            // Suggested Section
            Text(
              ProfileStrings.suggested,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._suggestedLanguages.map(
              (language) => _buildLanguageOption(
                context: context,
                language: language,
                isSelected: _selectedLanguage == language,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            // All Languages Section
            Text(
              ProfileStrings.language,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._allLanguages.map(
              (language) => _buildLanguageOption(
                context: context,
                language: language,
                isSelected: _selectedLanguage == language,
                onTap: () {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Radio<String>(
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
