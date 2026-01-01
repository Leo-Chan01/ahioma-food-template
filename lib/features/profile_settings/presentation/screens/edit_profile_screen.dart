import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/date_picker_field.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/dropdown_field.dart';
import 'package:ahioma_food_template/shared/data/country_codes.dart';
import 'package:ahioma_food_template/shared/global_snackbar.dart';
import 'package:ahioma_food_template/shared/models/country_code.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const String path = '/profile/edit-profile';
  static const String name = 'edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();

  CountryCode _selectedCountry = kCountryCodes.first;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _fullNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _countryController.text = _selectedCountry.name;
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
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
          ProfileStrings.editProfile,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name (read-only or display)
              _buildDisplayField(
                context: context,
                label: ProfileStrings.fullName,
                value: _fullNameController.text,
              ),
              const SizedBox(height: 16),
              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: ProfileStrings.firstName,
                ),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              // Date of Birth
              DatePickerField(
                controller: _dateOfBirthController,
                label: ProfileStrings.dateOfBirth,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: ProfileStrings.email,
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
              ),
              const SizedBox(height: 16),
              // Country
              DropdownField(
                controller: _countryController,
                label: ProfileStrings.country,
                items: kCountryCodes.map((country) => country.name).toList(),
                onSelected: (value) {
                  final selected = kCountryCodes.firstWhere(
                    (country) => country.name == value,
                    orElse: () => _selectedCountry,
                  );
                  setState(() {
                    _selectedCountry = selected;
                    _countryController.text = selected.name;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Phone Number
              Row(
                children: [
                  Expanded(
                    flex: 4,
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
                        labelText: ProfileStrings.phoneNumber,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Gender
              DropdownField(
                controller: _genderController,
                label: ProfileStrings.gender,
                items: const [
                  ProfileStrings.male,
                  ProfileStrings.female,
                  ProfileStrings.other,
                ],
                onSelected: (value) {
                  setState(() {
                    _genderController.text = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Update Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    GlobalSnackBar.showInfo(
                      ProfileStrings.profileUpdateComingSoon,
                    );
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  ProfileStrings.update,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayField({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _prefillFromProfile() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.fetchCustomerProfile();
    final customer = authProvider.customer;
    if (!mounted || customer == null) {
      return;
    }

    setState(() {
      _fullNameController.text = customer.fullName;
      _firstNameController.text = customer.firstName;
      _emailController.text = customer.email;
      _genderController.text = (customer.gender?.isNotEmpty ?? false)
          ? _formatName(customer.gender!)
          : '';

      _selectedDate = customer.dateOfBirth;
      if (_selectedDate != null) {
        _dateOfBirthController.text = DateFormat(
          'MM/dd/yyyy',
        ).format(_selectedDate!);
      }

      _selectedCountry = matchCountryFromPhone(customer.phoneNumber);
      _countryController.text = _selectedCountry.name;
      _phoneController.text = _extractLocalPhone(
        customer.phoneNumber ?? '',
        _selectedCountry,
      );
    });
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
        _countryController.text = selected.name;
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

  String _formatName(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
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
          labelText: ProfileStrings.countryCode,
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
            AppIcons.chevronDown(
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
