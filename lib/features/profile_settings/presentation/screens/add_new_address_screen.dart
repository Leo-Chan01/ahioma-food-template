import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_request_entity.dart';
import 'package:ahioma_food_template/features/checkout/domain/repository/checkout_repository.dart';
import 'package:ahioma_food_template/injection_container.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  static const String path = '/profile/add-new-address';
  static const String name = 'add-new-address';

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;
  bool _isLoading = false;

  final CheckoutRepository _checkoutRepository = sl<CheckoutRepository>();

  @override
  void dispose() {
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = AddAddressRequestEntity(
        address1: _address1Controller.text.trim(),
        address2: _address2Controller.text.trim().isEmpty
            ? null
            : _address2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: _countryController.text.trim(),
        isDefault: _isDefault,
      );

      await _checkoutRepository.addCustomerAddress(request);

      // Refresh customer profile to get updated addresses
      if (mounted) {
        final authProvider = context.read<AuthProvider>();
        await authProvider.fetchCustomerProfile(forceRefresh: true);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add address: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          ProfileStrings.addNewAddress,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(color: colorScheme.onSurface),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Map Section
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   color: colorScheme.surfaceContainerHighest,
              //   child: Stack(
              //     children: [
              //       // Placeholder map view
              //       Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             AppIcons.location(
              //               color: colorScheme.onSurfaceVariant,
              //               size: 48,
              //             ),
              //             const SizedBox(height: 8),
              //             Text(
              //               'Map View',
              //               style: theme.textTheme.bodyMedium?.copyWith(
              //                 color: colorScheme.onSurfaceVariant,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       // Map Pin
              //       Center(
              //         child: Container(
              //           width: 56,
              //           height: 56,
              //           decoration: BoxDecoration(
              //             color: colorScheme.primary,
              //             shape: BoxShape.circle,
              //           ),
              //           child: Center(
              //             child: Container(
              //               width: 24,
              //               height: 24,
              //               decoration: const BoxDecoration(
              //                 color: Colors.white,
              //                 shape: BoxShape.circle,
              //               ),
              //               child: ClipOval(
              //                 child: Image.network(
              //                   'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Address Details Form
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Drag Handle
                        // Center(
                        //   child: Container(
                        //     width: 40,
                        //     height: 4,
                        //     margin: const EdgeInsets.only(bottom: 16),
                        //     decoration: BoxDecoration(
                        //       color: colorScheme.outlineVariant,
                        //       borderRadius: BorderRadius.circular(2),
                        //     ),
                        //   ),
                        // ),
                        Text(
                          ProfileStrings.addressDetails,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Address Line 1
                        TextFormField(
                          controller: _address1Controller,
                          decoration: const InputDecoration(
                            labelText: 'Address Line 1 *',
                          ),
                          style: theme.textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Address Line 1 is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Address Line 2
                        TextFormField(
                          controller: _address2Controller,
                          decoration: const InputDecoration(
                            labelText: 'Address Line 2',
                          ),
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        // City
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City *',
                          ),
                          style: theme.textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'City is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // State
                        TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State *',
                          ),
                          style: theme.textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'State is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Postal Code
                        TextFormField(
                          controller: _postalCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Postal Code *',
                          ),
                          style: theme.textTheme.bodyLarge,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Postal Code is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Country
                        TextFormField(
                          controller: _countryController,
                          decoration: const InputDecoration(
                            labelText: 'Country *',
                          ),
                          style: theme.textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Country is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Default Address Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              onChanged: (value) {
                                setState(() {
                                  _isDefault = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                ProfileStrings.makeDefaultAddress,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Add Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveAddress,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  ProfileStrings.add,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
