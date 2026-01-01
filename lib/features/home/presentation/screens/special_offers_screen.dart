import 'package:flutter/material.dart';
import 'package:ahioma_food_template/core/utils/app_icons.dart';
import 'package:ahioma_food_template/core/utils/strings/special_offers_strings.dart';
import 'package:ahioma_food_template/features/home/data/data_sources/local/special_offers_local_source.dart';
import 'package:ahioma_food_template/features/home/data/models/special_offer_model.dart';
import 'package:ahioma_food_template/features/home/presentation/widgets/special_offer_card_widget.dart';
import 'package:ahioma_food_template/features/home/presentation/widgets/special_offers_empty_state_widget.dart';

class SpecialOffersScreen extends StatefulWidget {
  const SpecialOffersScreen({super.key});

  static const String path = '/special-offers';
  static const String name = 'special-offers';

  @override
  State<SpecialOffersScreen> createState() => _SpecialOffersScreenState();
}

class _SpecialOffersScreenState extends State<SpecialOffersScreen> {
  final SpecialOffersLocalSource _offersSource = SpecialOffersLocalSource();
  List<SpecialOfferModel> _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  Future<void> _loadOffers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final offers = await _offersSource.getSpecialOffers();
      setState(() {
        _offers = offers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: AppIcons.arrowBack(color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          SpecialOffersStrings.specialOffers,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: AppIcons.moreVertical(
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // TODO: Implement more options
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator.adaptive(
              onRefresh: _loadOffers,
              child: _offers.isEmpty
                  ? const SpecialOffersEmptyStateWidget()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _offers.length,
                      itemBuilder: (context, index) {
                        return SpecialOfferCardWidget(
                          offer: _offers[index],
                          onTap: () {
                            // TODO: Handle offer tap
                          },
                        );
                      },
                    ),
            ),
    );
  }
}
