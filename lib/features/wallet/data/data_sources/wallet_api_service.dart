import 'package:dio/dio.dart';
import 'package:ahioma_food_template/core/api/base_response.dart';
import 'package:ahioma_food_template/core/constants/app_constants.dart';
import 'package:ahioma_food_template/features/wallet/data/models/payment_credentials.dart';
import 'package:retrofit/retrofit.dart';

part 'wallet_api_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class WalletApiService {
  factory WalletApiService(Dio dio) => _WalletApiService(dio);

  @POST('/api/storefront/customers/payments/initialize')
  Future<BaseResponse<PaymentCredentialsModel>> initializePayment({
    @Body() required Map<String, dynamic> body,
  });

  @POST('/api/storefront/customers/payments/topup')
  Future<BaseResponse<PaymentCredentialsModel>> topUpWallet({
    @Body() required Map<String, dynamic> body,
  });

  @POST('/api/storefront/customers/payments/wallet')
  Future<BaseResponse<PaymentCredentialsModel>> payWithWallet({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/api/storefront/customers/payments/verify')
  Future<BaseResponse<PaymentCredentialsModel>> verifyPayment({
    @Query('reference') required String reference,
  });

  @GET('/api/storefront/customers/wallet/balance')
  Future<BaseResponse<PaymentCredentialsModel>> getWalletBalance();

  @GET('/api/storefront/customers/wallet/transactions')
  Future<BaseResponse<List<PaymentCredentialsModel>>> getWalletTransactions({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('transactionType') required String transactionType,
    @Query('status') required String status,
  });

  @POST('/api/storefront/customers/payments/webhook')
  Future<BaseResponse<PaymentCredentialsModel>> handlePaystackWebhook({
    @Body() required Map<String, dynamic> body,
    @Header('x-paystack-signature') required String paystackSignature,
  });
}
