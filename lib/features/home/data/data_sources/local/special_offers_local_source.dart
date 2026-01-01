import 'package:ahioma_food_template/features/home/data/models/special_offer_model.dart';

class SpecialOffersLocalSource {
  factory SpecialOffersLocalSource() {
    return _instance;
  }
  SpecialOffersLocalSource._();

  static final SpecialOffersLocalSource _instance =
      SpecialOffersLocalSource._();

  final List<Map<String, dynamic>> _offersDatabase = [
    {
      'id': '1',
      'discount': '30%',
      'title': "Today's Special!",
      'description': 'Get discount for every order, only valid for today',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    },
    {
      'id': '2',
      'discount': '25%',
      'title': 'Weekends Deals',
      'description': 'Get discount for every order, only valid for today',
      'imageUrl':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    },
    {
      'id': '3',
      'discount': '40%',
      'title': 'New Arrivals',
      'description': 'Get discount for every order, only valid for today',
      'imageUrl':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
    },
    {
      'id': '4',
      'discount': '20%',
      'title': 'Black Friday',
      'description': 'Get discount for every order, only valid for today',
      'imageUrl':
          'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=400',
    },
  ];

  Future<List<SpecialOfferModel>> getSpecialOffers() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _offersDatabase.map(SpecialOfferModel.fromJson).toList();
  }
}
