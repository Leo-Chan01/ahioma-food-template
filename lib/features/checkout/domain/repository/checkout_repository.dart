import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_request_entity.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_response_entity.dart';

abstract class CheckoutRepository {
  /// Add customer address (Requires authentication)
  Future<AddAddressResponseEntity> addCustomerAddress(
    AddAddressRequestEntity request,
  );
}
