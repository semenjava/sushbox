import 'package:dio/dio.dart';
import 'dart:convert';

class VivaPaymentsService {
  final Dio _dio = Dio();

  // Замените значения на ваши Merchant ID и API Key
  final String _merchantId = 'dbd9951e-3f82-4d86-be11-b511c5007730';
  final String _apiKey = '1Y6CvCfZ0r5G3Gj7ra7696ZWUa60nY';

  VivaPaymentsService() {
    _dio.options
      ..baseUrl = 'https://demo-api.vivapayments.com/checkout/v2/'
      ..headers = {
        'Authorization': 'Basic ${_encodeCredentials(_merchantId, _apiKey)}',
        'Content-Type': 'application/json',
      };
  }

  String _encodeCredentials(String merchantId, String apiKey) {
    return base64Encode(utf8.encode('$merchantId:$apiKey'));
  }

  Future<Response> createPayment({
    required double amount,
    required String currency,
    required String description,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        'orders',
        data: {
          'tags': ['Sample string 1', 'Sample string 2', 'Sample string 3'],
          'email': email,
          'phone': '2117604000', // Пример телефона
          'fullName': 'Customer name', // Пример имени
          'paymentTimeOut': 86400,
          'requestLang': 'en-GB',
          'maxInstallments': 12,
          'allowRecurring': true,
          'isPreAuth': true,
          'amount':
              (amount * 100).toInt(), // Пример преобразования в единицы валюты
          'merchantTrns': description,
          'customerTrns':
              'Short description of items/services purchased to display to your customer'
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }
}
