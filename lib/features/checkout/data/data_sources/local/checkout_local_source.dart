import 'package:ahioma_food_template/features/checkout/data/models/payment_method_model.dart';
import 'package:ahioma_food_template/features/checkout/data/models/promo_code_model.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_address_model.dart';
import 'package:ahioma_food_template/features/checkout/data/models/shipping_option_model.dart';

class CheckoutLocalSource {
  factory CheckoutLocalSource() {
    return _instance;
  }
  CheckoutLocalSource._();

  static final CheckoutLocalSource _instance = CheckoutLocalSource._();

  // Shipping options
  final List<Map<String, dynamic>> _shippingOptionsDatabase = [
    {
      'id': '1',
      'name': 'Economy',
      'price': 10.0,
      'estimatedArrival': 'Estimated Arrival, Dec 20-23',
      'iconName': 'check',
    },
    {
      'id': '2',
      'name': 'Regular',
      'price': 15.0,
      'estimatedArrival': 'Estimated Arrival, Dec 20-22',
      'iconName': 'box',
    },
    {
      'id': '3',
      'name': 'Cargo',
      'price': 20.0,
      'estimatedArrival': 'Estimated Arrival, Dec 19-20',
      'iconName': 'truck',
    },
    {
      'id': '4',
      'name': 'Express',
      'price': 30.0,
      'estimatedArrival': 'Estimated Arrival, Dec 18-19',
      'iconName': 'express',
    },
  ];

  // Payment methods
  final List<Map<String, dynamic>> _paymentMethodsDatabase = [
    {
      'id': '1',
      'name': 'My Wallet',
      'type': 'wallet',
      'balance': 9379.0,
      'iconName': 'wallet',
    },
    {'id': '2', 'name': 'Paystack', 'type': 'external', 'iconName': 'paystack'},
    // {
    //   'id': '5',
    //   'name': 'Mastercard',
    //   'type': 'creditcard',
    //   'cardNumber': '.... .... .... 4679',
    //   'iconName': 'mastercard',
    // },
  ];

  // Promo codes
  final List<Map<String, dynamic>> _promoCodesDatabase = [
    {
      'id': '1',
      'code': 'SPECIAL25',
      'discountPercent': 25,
      'description': 'Special promo only today!',
    },
    {
      'id': '2',
      'code': 'NEWUSER30',
      'discountPercent': 30,
      'description': 'New user special promo',
    },
    {
      'id': '3',
      'code': 'SPECIAL20',
      'discountPercent': 20,
      'description': 'Special promo only today!',
    },
    {
      'id': '4',
      'code': 'SPECIAL40',
      'discountPercent': 40,
      'description': 'Special promo only valid today',
    },
    {
      'id': '5',
      'code': 'SPECIAL35',
      'discountPercent': 35,
      'description': 'Special promo only today!',
    },
  ];

  // Note: Shipping addresses are now retrieved from the customer profile
  // This method is kept for backward compatibility but should not be used
  @Deprecated('Use addresses from CustomerModel instead')
  Future<List<ShippingAddressModel>> getShippingAddresses() async {
    return [];
  }

  Future<List<ShippingOptionModel>> getShippingOptions() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _shippingOptionsDatabase.map(ShippingOptionModel.fromJson).toList();
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _paymentMethodsDatabase.map(PaymentMethodModel.fromJson).toList();
  }

  Future<List<PromoCodeModel>> getPromoCodes() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _promoCodesDatabase.map(PromoCodeModel.fromJson).toList();
  }
}
