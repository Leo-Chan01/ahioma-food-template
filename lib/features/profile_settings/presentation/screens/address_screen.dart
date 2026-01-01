import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/screens/add_new_address_screen.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/address_item_widget.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  static const String path = '/profile/address';
  static const String name = 'address';

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<Address> _addresses = [
    Address(
      id: '1',
      name: ProfileStrings.home,
      address: '61480 Sunbrook Park, PC 5679',
      isDefault: true,
    ),
    Address(
      id: '2',
      name: ProfileStrings.office,
      address: '6993 Meadow Valley Terra, PC 3637',
      isDefault: false,
    ),
    Address(
      id: '3',
      name: ProfileStrings.apartment,
      address: '21833 Clyde Gallagher, PC 4662',
      isDefault: false,
    ),
    Address(
      id: '4',
      name: ProfileStrings.parentsHouse,
      address: '5259 Blue Bill Park, PC 4627',
      isDefault: false,
    ),
    Address(
      id: '5',
      name: ProfileStrings.townSquare,
      address: '5375 Summerhouse, PC 4627',
      isDefault: false,
    ),
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
          ProfileStrings.address,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AddressItemWidget(
                      address: _addresses[index],
                      onEdit: () {
                        // TODO: Navigate to edit address
                      },
                    ),
                  );
                },
              ),
            ),
            // Add New Address Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(AddNewAddressScreen.path);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    ProfileStrings.addNewAddress,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  Address({
    required this.id,
    required this.name,
    required this.address,
    required this.isDefault,
  });

  final String id;
  final String name;
  final String address;
  final bool isDefault;
}
