import 'package:ahioma_food_template/shared/models/country_code.dart';

const List<CountryCode> kCountryCodes = [
  CountryCode(
    name: 'Nigeria',
    dialCode: '+234',
    flag: '🇳🇬',
    isoCode: 'NG',
  ),
  CountryCode(
    name: 'United States',
    dialCode: '+1',
    flag: '🇺🇸',
    isoCode: 'US',
  ),
  CountryCode(
    name: 'Canada',
    dialCode: '+1',
    flag: '🇨🇦',
    isoCode: 'CA',
  ),
  CountryCode(
    name: 'United Kingdom',
    dialCode: '+44',
    flag: '🇬🇧',
    isoCode: 'GB',
  ),
  CountryCode(
    name: 'Ghana',
    dialCode: '+233',
    flag: '🇬🇭',
    isoCode: 'GH',
  ),
  CountryCode(
    name: 'South Africa',
    dialCode: '+27',
    flag: '🇿🇦',
    isoCode: 'ZA',
  ),
  CountryCode(
    name: 'Kenya',
    dialCode: '+254',
    flag: '🇰🇪',
    isoCode: 'KE',
  ),
  CountryCode(
    name: 'Germany',
    dialCode: '+49',
    flag: '🇩🇪',
    isoCode: 'DE',
  ),
  CountryCode(
    name: 'Australia',
    dialCode: '+61',
    flag: '🇦🇺',
    isoCode: 'AU',
  ),
  CountryCode(
    name: 'India',
    dialCode: '+91',
    flag: '🇮🇳',
    isoCode: 'IN',
  ),
];

CountryCode matchCountryByDialCode(String? dialCode) {
  if (dialCode == null || dialCode.isEmpty) {
    return kCountryCodes.first;
  }
  final normalised = dialCode.startsWith('+') ? dialCode : '+$dialCode';
  return kCountryCodes.firstWhere(
    (country) => normalised.startsWith(country.dialCode),
    orElse: () => kCountryCodes.first,
  );
}

CountryCode matchCountryFromPhone(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return kCountryCodes.first;
  }
  final sanitised = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  return kCountryCodes.firstWhere(
    (country) {
      final dial = country.dialCode;
      final withoutPlus = dial.replaceFirst('+', '');
      return sanitised.startsWith(dial) || sanitised.startsWith(withoutPlus);
    },
    orElse: () => kCountryCodes.first,
  );
}
