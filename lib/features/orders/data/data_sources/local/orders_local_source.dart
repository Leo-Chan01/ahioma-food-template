import 'package:ahioma_food_template/features/orders/data/models/order_model.dart';

class OrdersLocalSource {
  factory OrdersLocalSource() {
    return _instance;
  }
  OrdersLocalSource._();

  static final OrdersLocalSource _instance = OrdersLocalSource._();

  final List<Map<String, dynamic>> _ordersDatabase = [
    {
      'id': '1',
      'productName': 'Suga Leather Shoes',
      'productImage':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      'color': 'Color',
      'size': 'XL',
      'quantity': 1,
      'price': 375.00,
      'status': 'ongoing',
      'currentTrackingStatus': 'Packet In Delivery',
      'statusDetails': [
        {
          'title': 'Order in Transit - Dec 17',
          'description': '32 Manchester Ave, Ringgold, GA 30736',
          'date': 'Dec 17',
          'time': '10:00 PM',
          'isCompleted': true,
        },
        {
          'title': 'Order ... Customs Port - Dec 16',
          'description': '1110 Elida Avenue, Delphos, OH 45833',
          'date': 'Dec 16',
          'time': '6:00 PM',
          'isCompleted': true,
        },
        {
          'title': 'Orders are ... Shipped - Dec 15',
          'description': '1110 Elida Avenue, Delphos, OH 45833',
          'date': 'Dec 15',
          'time': '8:00 AM',
          'isCompleted': true,
        },
        {
          'title': 'Order is in Packing - Dec 15',
          'description': '89 Cogan Ridge, MV 26508',
          'date': 'Dec 15',
          'time': '10:55 AM',
          'isCompleted': false,
        },
        {
          'title': 'Verified Payments - Dec 15',
          'description': '55 Summerhouse Dr, Algeles FL, 33913',
          'date': 'Dec 15',
          'time': '10:04 AM',
          'isCompleted': false,
        },
      ],
      'hasReview': false,
    },
    {
      'id': '2',
      'productName': 'Werala Cardigans',
      'productImage':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400',
      'color': 'Brown',
      'size': 'L',
      'quantity': 1,
      'price': 385.00,
      'status': 'ongoing',
      'currentTrackingStatus': 'Order in Transit',
      'statusDetails': [
        {
          'title': 'Order in Transit - Dec 17',
          'description': '32 Manchester Ave, Ringgold, GA 30736',
          'date': 'Dec 17',
          'time': '10:00 PM',
          'isCompleted': true,
        },
        {
          'title': 'Order ... Customs Port - Dec 16',
          'description': '1110 Elida Avenue, Delphos, OH 45833',
          'date': 'Dec 16',
          'time': '6:00 PM',
          'isCompleted': false,
        },
      ],
      'hasReview': false,
    },
    {
      'id': '3',
      'productName': 'Vinju Headphone',
      'productImage':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      'color': 'Techwood',
      'size': 'M',
      'quantity': 1,
      'price': 360.00,
      'status': 'ongoing',
      'currentTrackingStatus': 'Shipped',
      'statusDetails': [
        {
          'title': 'Orders are ... Shipped - Dec 15',
          'description': '1110 Elida Avenue, Delphos, OH 45833',
          'date': 'Dec 15',
          'time': '8:00 AM',
          'isCompleted': true,
        },
      ],
      'hasReview': false,
    },
    {
      'id': '4',
      'productName': 'Sonia Headphone',
      'productImage':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      'color': 'Color',
      'size': 'L',
      'quantity': 1,
      'price': 325.00,
      'status': 'completed',
      'currentTrackingStatus': 'Delivered',
      'statusDetails': <Map<String, dynamic>>[],
      'hasReview': false,
    },
    {
      'id': '5',
      'productName': 'Minit Leather Bag',
      'productImage':
          'https://images.unsplash.com/photo-1491637639811-60e2756cc1c7?w=400',
      'color': 'Color',
      'size': 'XL',
      'quantity': 1,
      'price': 640.00,
      'status': 'completed',
      'currentTrackingStatus': 'Delivered',
      'statusDetails': <Map<String, dynamic>>[],
      'hasReview': false,
    },
    {
      'id': '6',
      'productName': 'Puma Sneaker Shoe',
      'productImage':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'color': 'Color',
      'size': 'XL',
      'quantity': 1,
      'price': 390.00,
      'status': 'completed',
      'currentTrackingStatus': 'Delivered',
      'statusDetails': <Map<String, dynamic>>[],
      'hasReview': false,
    },
    {
      'id': '7',
      'productName': 'Pulfilm Camera',
      'productImage':
          'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400',
      'color': 'Color',
      'size': 'XL',
      'quantity': 1,
      'price': 890.00,
      'status': 'completed',
      'currentTrackingStatus': 'Delivered',
      'statusDetails': <Map<String, dynamic>>[],
      'hasReview': false,
    },
  ];

  Future<List<OrderModel>> getOngoingOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _ordersDatabase
        .where((order) => order['status'] == 'ongoing')
        .map(OrderModel.fromJson)
        .toList();
  }

  Future<List<OrderModel>> getCompletedOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _ordersDatabase
        .where((order) => order['status'] == 'completed')
        .map(OrderModel.fromJson)
        .toList();
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      final orderData = _ordersDatabase.firstWhere(
        (order) => order['id'] == orderId,
      );
      return OrderModel.fromJson(orderData);
    } catch (e) {
      return null;
    }
  }

  Future<void> submitReview(String orderId, int rating, String comment) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final orderIndex = _ordersDatabase.indexWhere(
      (order) => order['id'] == orderId,
    );
    if (orderIndex != -1) {
      _ordersDatabase[orderIndex]['hasReview'] = true;
    }
  }
}
