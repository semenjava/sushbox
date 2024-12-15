import 'package:sushibox/data/model/response/language_model.dart';
import 'package:sushibox/utill/images.dart';

class AppConstants {
  static const String appName = '';
  static const double appVersion = 10.2;
  static const String baseUrl =
      'https://app.sushi-box.gr'; //'https://app.sushi-box.gr'; //'http://10.0.2.2:8000';
  static const String profileUri = '/api/v1/delivery-man/profile?token=';
  static const String configUri = '/api/v1/config';
  static const String bannerUri = '/api/v1/banners';
  static const String searchUri = '/api/v1/products/searched';
  static const String categoryUri = '/api/v1/categories/list';
  static const String productsLatestUri = '/api/v1/products/latested';
  static const String loginUri = '/api/v1/auth/delivery-man/login';
  static const String notificationUri = '/api/v1/notifications';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String currentOrdersUri =
      '/api/v1/delivery-man/current-orders?token=';
  static const String orderDetailsUri =
      '/api/v1/delivery-man/order-details?token=';
  static const String orderHistoryUri =
      '/api/v1/delivery-man/all-orders?token=';
  static const String productListUri = '/api/v1/products/list/';
  static const String recordLocationUri =
      '/api/v1/delivery-man/record-location-data';
  static const String updateOrderStatusUri =
      '/api/v1/delivery-man/update-order-status';
  static const String updatePaymentStatusUri =
      '/api/v1/delivery-man/update-payment-status';
  static const String tokenUri = '/api/v1/delivery-man/update-fcm-token';
  static const String getMessageUri =
      '/api/v1/delivery-man/message/get-message';
  static const String sendMessageUri =
      '/api/v1/delivery-man/message/send/deliveryman';
  static const String getOrderModel = '/api/v1/delivery-man/order-model?token=';
  static const String register = '/api/v1/auth/delivery-man/register';

  // Shared Key
  static const String theme = 'theme';
  static const String token = 'auth_token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userEmail = 'user_email';
  static const String orderId = 'order_id';
  static const String imageFolder = '/storage/';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: Images.unitedKingdom,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
    LanguageModel(
        imageUrl: Images.greece,
        languageName: 'Greece',
        countryCode: 'GR',
        languageCode: 'el'),
    LanguageModel(
        imageUrl: Images.greece,
        languageName: 'Russian',
        countryCode: 'RU',
        languageCode: 'ru'),
  ];
}
