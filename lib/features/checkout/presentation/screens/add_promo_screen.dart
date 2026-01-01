import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/checkout_strings.dart';
import 'package:ahioma_food_template/features/checkout/data/data_sources/local/checkout_local_source.dart';
import 'package:ahioma_food_template/features/checkout/data/models/promo_code_model.dart';

class AddPromoScreen extends StatefulWidget {
  const AddPromoScreen({super.key});

  static const String path = '/add-promo';
  static const String name = 'add-promo';

  @override
  State<AddPromoScreen> createState() => _AddPromoScreenState();
}

class _AddPromoScreenState extends State<AddPromoScreen> {
  final CheckoutLocalSource _localSource = CheckoutLocalSource();
  final TextEditingController _searchController = TextEditingController();
  List<PromoCodeModel> _promoCodes = [];
  List<PromoCodeModel> _filteredPromoCodes = [];
  String? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPromoCodes();
    _searchController.addListener(_filterPromoCodes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPromoCodes() async {
    final codes = await _localSource.getPromoCodes();
    setState(() {
      _promoCodes = codes;
      _filteredPromoCodes = codes;
      _selectedId = codes[1].id; // Default to second promo
      _isLoading = false;
    });
  }

  void _filterPromoCodes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPromoCodes = _promoCodes;
      } else {
        _filteredPromoCodes = _promoCodes
            .where(
              (code) =>
                  code.code.toLowerCase().contains(query) ||
                  code.description.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CheckoutStrings.addPromo,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: AppIcons.search(color: theme.colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(16),
                  //   child: TextField(
                  //     controller: _searchController,
                  //     decoration: InputDecoration(
                  //       hintText: 'Search promo codes...',
                  //       prefixIcon: AppIcons.search(
                  //         color: theme.colorScheme.onSurface.withValues(
                  //           alpha: 0.5,
                  //         ),
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredPromoCodes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final promo = _filteredPromoCodes[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RadioListTile<String>(
                            value: promo.id,
                            groupValue: _selectedId,
                            onChanged: (value) {
                              setState(() {
                                _selectedId = value;
                              });
                            },
                            title: Text(
                              'Special ${promo.discountPercent}% Off',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                promo.description,
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
                              child: AppIcons.ticket(
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final selected = _filteredPromoCodes.firstWhere(
                            (p) => p.id == _selectedId,
                          );
                          Navigator.of(context).pop(selected.code);
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
            ),
    );
  }
}
