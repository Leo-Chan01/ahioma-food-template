import 'package:ahioma_food_template/features/fund_management/data/models/transaction_model.dart';

class WalletLocalSource {
  factory WalletLocalSource() {
    return _instance;
  }
  WalletLocalSource._();

  static final WalletLocalSource _instance = WalletLocalSource._();

  static const double _balance = 9379;
  static const String _cardholderName = 'Andrew Ainsley';
  static const String _cardNumber = '•••• •••• •••• 3629';

  double get balance => _balance;
  String get cardholderName => _cardholderName;
  String get cardNumber => _cardNumber;

  final List<Map<String, dynamic>> _transactionsDatabase = [
    {
      'id': '1',
      'title': 'Suga Leather Shoes',
      'amount': 262.5,
      'date': 'Dec 15, 2024',
      'time': '10:00 AM',
      'type': 'order',
      'imageUrl':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      'productName': 'Suga Leather Shoes',
    },
    {
      'id': '2',
      'title': 'Top Up Wallet',
      'amount': 500.0,
      'date': 'Dec 14, 2024',
      'time': '16:42 PM',
      'type': 'topUp',
      'imageUrl': null,
      'productName': null,
    },
    {
      'id': '3',
      'title': 'Werolla Cardigans',
      'amount': 385.0,
      'date': 'Dec 14, 2024',
      'time': '11:39 AM',
      'type': 'order',
      'imageUrl':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
      'productName': 'Werolla Cardigans',
    },
    {
      'id': '4',
      'title': 'Mini Leather Bag',
      'amount': 540.0,
      'date': 'Dec 13, 2024',
      'time': '14:46 PM',
      'type': 'order',
      'imageUrl':
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
      'productName': 'Mini Leather Bag',
    },
    {
      'id': '5',
      'title': 'Top Up Wallet',
      'amount': 550.0,
      'date': 'Dec 12, 2024',
      'time': '09:27 AM',
      'type': 'topUp',
      'imageUrl': null,
      'productName': null,
    },
  ];

  Future<List<TransactionModel>> getTransactions() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _transactionsDatabase.map(TransactionModel.fromJson).toList();
  }
}
