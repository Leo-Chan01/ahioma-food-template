import 'package:ahioma_food_template/features/cart/data/models/cart/cart_item_model.dart';

class CartLocalSource {
  factory CartLocalSource() {
    return _instance;
  }
  CartLocalSource._();

  static final CartLocalSource _instance = CartLocalSource._();

  final List<Map<String, dynamic>> _cartDatabase = [
    {
      'id': '1',
      'product': {
        'id': 'p1',
        'name': 'Product 1',
        'description': 'Description for Product 1',
        'price': 29.99,
        'imageUrl': 'https://example.com/product1.jpg',
      },
      'quantity': 2,
      'price': 59.98,
    },
    {
      'id': '2',
      'product': {
        'id': 'p2',
        'name': 'Product 3',
        'description': 'Description for Product 1',
        'price': 29.99,
        'imageUrl': 'https://example.com/product1.jpg',
      },
      'quantity': 2,
      'price': 59.98,
    },
    {
      'id': '3',
      'product': {
        'id': 'p3',
        'name': 'Product 3',
        'description': 'Description for Product 3',
        'price': 19.99,
        'imageUrl': 'https://example.com/product3.jpg',
      },
      'quantity': 1,
      'price': 19.99,
    },
  ];

  Future<List<CartItemModel>> getCartItems() async {
    // Simulate a delay for fetching data
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _cartDatabase.map(CartItemModel.fromJson).toList();
  }
}
