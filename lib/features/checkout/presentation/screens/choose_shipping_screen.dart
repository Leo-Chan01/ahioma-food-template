import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/checkout/data/data_sources/local/checkout_local_source.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_option_model.dart';

class ChooseShippingScreen extends StatefulWidget {
  const ChooseShippingScreen({super.key});

  static const String path = '/choose-shipping';
  static const String name = 'choose-shipping';

  @override
  State<ChooseShippingScreen> createState() => _ChooseShippingScreenState();
}

class _ChooseShippingScreenState extends State<ChooseShippingScreen> {
  final CheckoutLocalSource _localSource = CheckoutLocalSource();
  List<ShippingOptionModel> _options = [];
  String? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final options = await _localSource.getShippingOptions();
    setState(() {
      _options = options;
      _selectedId = options[1].id; // Default to Regular
      _isLoading = false;
    });
  }

  Widget _getShippingIcon(String iconName) {
    switch (iconName) {
      case 'check':
        return AppIcons.check(color: Colors.white, size: 24);
      case 'box':
        return AppIcons.box(color: Colors.white, size: 24);
      case 'truck':
        return AppIcons.truck(color: Colors.white, size: 24);
      case 'express':
        return AppIcons.truck(color: Colors.white, size: 24);
      default:
        return AppIcons.box(color: Colors.white, size: 24);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.chooseShipping,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _options.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = _options[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile<String>(
                          value: option.id,
                          groupValue: _selectedId,
                          onChanged: (value) {
                            setState(() {
                              _selectedId = value;
                            });
                          },
                          title: Text(
                            option.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              option.estimatedArrival,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                          secondary: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${option.price.toStringAsFixed(0)}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: _getShippingIcon(option.iconName),
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final selected = _options.firstWhere(
                          (o) => o.id == _selectedId,
                        );
                        Navigator.of(context).pop(selected);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        CheckoutStrings.apply,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
