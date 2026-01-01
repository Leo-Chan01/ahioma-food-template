import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/onboarding_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/account_setup_provider.dart';
import 'package:ahioma_food_template/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/screens/create_new_pin_screen.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/widgets/profile_date_picker_field.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/widgets/profile_dropdown_field.dart';
import 'package:ahioma_food_template/features/onboarding/presentation/widgets/profile_picture_widget.dart';
import 'package:ahioma_food_template/shared/data/country_codes.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/models/country_code.dart';
import 'package:provider/provider.dart';

class FillYourProfileScreen extends StatefulWidget {
  const FillYourProfileScreen({super.key});

  static const String path = '/onboarding/fill-profile';
  static const String name = 'fill-profile';

  @override
  State<FillYourProfileScreen> createState() => _FillYourProfileScreenState();
}

class _FillYourProfileScreenState extends State<FillYourProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  CountryCode _selectedCountry = kCountryCodes.first;
  String? _profileImageUrl;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate =
        _selectedDate ?? DateTime.now().subtract(const Duration(days: 6570));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate, // default to ~18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = _formatDate(picked);
      });
    }
  }

  void _handleProfileImageChanged(String? imageUrl) {
    setState(() {
      _profileImageUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AccountSetupProvider>();
      if (!provider.hasCredentials) {
        context.goNamed(SignUpScreen.name);
        return;
      }
      _prefillFromProvider(provider);
    });
  }

  void _prefillFromProvider(AccountSetupProvider provider) {
    _fullNameController.text = provider.fullName ?? '';
    _nicknameController.text = provider.nickname ?? '';
    _emailController.text = provider.email ?? '';
    final initialPhone = provider.phoneNumber ?? '';
    _selectedCountry = matchCountryFromPhone(
      provider.countryCode ?? initialPhone,
    );
    _phoneController.text = _extractLocalPhone(initialPhone, _selectedCountry);
    _genderController.text = provider.gender ?? '';
    _profileImageUrl = provider.profileImagePath;
    _selectedDate = provider.dateOfBirth;
    if (_selectedDate != null) {
      _dateOfBirthController.text = _formatDate(_selectedDate!);
    }
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  void _submitProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_selectedDate == null) {
      GlobalSnackBar.showWarning(OnboardingStrings.dateOfBirthRequired);
      return;
    }
    if (_genderController.text.trim().isEmpty) {
      GlobalSnackBar.showWarning(OnboardingStrings.genderRequired);
      return;
    }

    context.read<AccountSetupProvider>().updateProfile(
      fullName: _fullNameController.text,
      nickname: _nicknameController.text,
      dateOfBirth: _selectedDate!,
      email: _emailController.text,
      phoneNumber:
          '${_selectedCountry.dialCode}${_phoneController.text.trim()}',
      gender: _genderController.text,
      countryCode: _selectedCountry.dialCode,
      profileImagePath: _profileImageUrl,
    );

    unawaited(context.pushNamed(CreateNewPinScreen.name));
  }

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
          OnboardingStrings.fillYourProfile,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Profile Picture
              ProfilePictureWidget(
                imageUrl: _profileImageUrl,
                onImageChanged: _handleProfileImageChanged,
              ),
              const SizedBox(height: 48),
              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: OnboardingStrings.fullName,
                ),
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return OnboardingStrings.fullNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Nickname
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: OnboardingStrings.nickname,
                ),
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return OnboardingStrings.nicknameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Date of Birth
              ProfileDatePickerField(
                controller: _dateOfBirthController,
                label: OnboardingStrings.dateOfBirth,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: OnboardingStrings.email,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: AppIcons.email(
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                style: theme.textTheme.bodyLarge,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return OnboardingStrings.emailRequired;
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return OnboardingStrings.emailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Phone Number
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _CountryCodeField(
                      selectedCountry: _selectedCountry,
                      onTap: () => _selectCountry(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 9,
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: OnboardingStrings.phoneNumber,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: theme.textTheme.bodyLarge,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return OnboardingStrings.phoneNumberRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Gender
              ProfileDropdownField(
                controller: _genderController,
                label: OnboardingStrings.gender,
                items: const [
                  OnboardingStrings.male,
                  OnboardingStrings.female,
                  OnboardingStrings.other,
                ],
                onSelected: (value) {
                  setState(() {
                    _genderController.text = value;
                  });
                },
              ),
              const SizedBox(height: 48),
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    OnboardingStrings.continueButton,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectCountry(BuildContext context) async {
    final selected = await showModalBottomSheet<CountryCode>(
      context: context,
      builder: (context) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: kCountryCodes.length,
          separatorBuilder: (context, index) => const Divider(height: 0),
          itemBuilder: (context, index) {
            final country = kCountryCodes[index];
            return ListTile(
              leading: Text(
                country.flag,
                style: const TextStyle(fontSize: 20),
              ),
              title: Text(country.name),
              trailing: Text(
                country.dialCode,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => Navigator.of(context).pop(country),
            );
          },
        );
      },
    );
    if (selected != null) {
      setState(() {
        _selectedCountry = selected;
      });
    }
  }

  String _extractLocalPhone(String fullNumber, CountryCode country) {
    if (fullNumber.isEmpty) return '';
    var sanitised = fullNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final dialWithoutPlus = country.dialCode.replaceFirst('+', '');
    if (sanitised.startsWith(country.dialCode)) {
      sanitised = sanitised.substring(country.dialCode.length);
    } else if (sanitised.startsWith(dialWithoutPlus)) {
      sanitised = sanitised.substring(dialWithoutPlus.length);
    }
    return sanitised;
  }
}

class _CountryCodeField extends StatelessWidget {
  const _CountryCodeField({
    required this.selectedCountry,
    required this.onTap,
  });

  final CountryCode selectedCountry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: OnboardingStrings.countryCode,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  selectedCountry.flag,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedCountry.dialCode,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            Flexible(
              child: AppIcons.chevronDown(
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
