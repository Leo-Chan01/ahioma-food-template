import 'package:ahioma_food_template/features/storefront/data/data_sources/remote/storefront_api_service.dart';
import 'package:ahioma_food_template/features/checkout/data/models/add_address_request_model.dart';
import 'package:ahioma_food_template/features/checkout/data/models/add_address_response_model.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_request_entity.dart';
import 'package:ahioma_food_template/features/checkout/domain/entities/add_address_response_entity.dart';
import 'package:ahioma_food_template/features/checkout/domain/repository/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._apiService);

  final StorefrontApiService _apiService;

  @override
  Future<AddAddressResponseEntity> addCustomerAddress(
    AddAddressRequestEntity request,
  ) async {
    final requestModel = AddAddressRequestModel(
      address1: request.address1,
      address2: request.address2,
      city: request.city,
      state: request.state,
      postalCode: request.postalCode,
      country: request.country,
      isDefault: request.isDefault,
    );

    final httpResponse = await _apiService.addCustomerAddress(requestModel);

    // Parse the response manually since API returns: {"success": true, "data": {"address": {...}}}
    final responseData = httpResponse.data;
    if (responseData == null) {
      throw Exception('Failed to add address: No data in response');
    }

    // Response should be: {"success": true, "data": {"address": {...}}}
    if (responseData is! Map<String, dynamic>) {
      throw Exception(
        'Failed to add address: Invalid response type. '
        'Expected Map, got: ${responseData.runtimeType}',
      );
    }

    // Extract data field from response
    if (!responseData.containsKey('data')) {
      throw Exception(
        'Failed to add address: Missing "data" field in response. '
        'Response: $responseData',
      );
    }

    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Failed to add address: Invalid data structure. '
        'Expected Map, got: ${data.runtimeType}',
      );
    }

    // Extract address from nested structure: data.address
    if (!data.containsKey('address')) {
      throw Exception(
        'Failed to add address: Address not found in response data. '
        'Response data: $data',
      );
    }

    final addressData = data['address'];
    if (addressData is! Map<String, dynamic>) {
      throw Exception(
        'Failed to add address: Invalid address data type. '
        'Expected Map, got: ${addressData.runtimeType}',
      );
    }

    try {
      final responseModel = AddAddressResponseModel.fromJson(addressData);
      return responseModel;
    } catch (e) {
      throw Exception(
        'Failed to parse address from response: $e. '
        'Address data: $addressData',
      );
    }
  }
}
