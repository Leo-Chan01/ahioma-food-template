import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_address_model.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/add_new_address_screen.dart';
import 'package:provider/provider.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  static const String path = '/shipping-address';
  static const String name = 'shipping-address';

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  List<ShippingAddressModel> _addresses = [];
  String? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses({bool forceRefresh = true}) async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    // Force refresh to get latest addresses
    await authProvider.fetchCustomerProfile(forceRefresh: forceRefresh);

    if (mounted) {
      final customer = authProvider.customer;
      final addresses = customer?.addresses;

      setState(() {
        if (addresses != null && addresses.isNotEmpty) {
          // Convert AddAddressResponseModel to ShippingAddressModel
          _addresses = addresses
              .map((addr) => ShippingAddressModel.fromAddAddressResponse(addr))
              .toList();

          _selectedId = _addresses
              .firstWhere((a) => a.isDefault, orElse: () => _addresses.first)
              .id;
        } else {
          _addresses = [];
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.shippingAddress,
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
                    itemCount: _addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = _addresses[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile<String>(
                          value: address.id,
                          groupValue: _selectedId,
                          onChanged: (value) {
                            setState(() {
                              _selectedId = value;
                            });
                          },
                          title: Row(
                            children: [
                              Text(
                                address.label,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (address.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme
                                        .surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    CheckoutStrings.defaultTag,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              address.address,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                          secondary: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(12),
                            child: AppIcons.location(
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            // Navigate to add new address screen
                            await context.push(AddNewAddressScreen.path);
                            // Refresh addresses when returning
                            if (mounted) {
                              await _loadAddresses(forceRefresh: true);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(CheckoutStrings.addNewAddress),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final selected = _addresses.firstWhere(
                              (a) => a.id == _selectedId,
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
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
