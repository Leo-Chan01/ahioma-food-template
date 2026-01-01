class CountryCode {
  const CountryCode({
    required this.name,
    required this.dialCode,
    required this.flag,
    this.isoCode,
  });

  final String name;
  final String dialCode;
  final String flag;
  final String? isoCode;
}
