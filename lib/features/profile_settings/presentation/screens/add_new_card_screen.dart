import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/profile_strings.dart';
import 'package:ahioma_food_template/features/profile_settings/presentation/widgets/credit_card_widget.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  static const String path = '/profile/add-new-card';
  static const String name = 'add-new-card';

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController(text: 'Andrew Ainsley');
  final _cardNumberController = TextEditingController(
    text: '2672 4738 7837 7285',
  );
  final _expiryDateController = TextEditingController(text: '09/07/26');
  final _cvvController = TextEditingController(text: '699');

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
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
          ProfileStrings.addNewCard,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Credit Card Mockup
              CreditCardWidget(
                cardName: _cardNameController.text,
                cardNumber: _cardNumberController.text,
                expiryDate: _expiryDateController.text,
              ),
              const SizedBox(height: 32),
              // Card Name
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: ProfileStrings.cardName,
                ),
                style: theme.textTheme.bodyLarge,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              // Card Number
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: ProfileStrings.cardNumber,
                ),
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyLarge,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              // Expiry Date & CVV Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(
                        labelText: ProfileStrings.expiryDate,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppIcons.edit(
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.bodyLarge,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: ProfileStrings.cvv,
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Add Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Save card
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
                  ProfileStrings.add,
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
}
