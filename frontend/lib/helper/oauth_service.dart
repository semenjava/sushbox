import 'package:dio/dio.dart';

class OAuthService {
  final Dio _dio = Dio();

  Future<String?> getAccessToken() async {
    try {
      final response = await _dio.post(
        'https://demo-accounts.vivapayments.com/connect/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': 'YOUR_CLIENT_ID',
          'client_secret': 'YOUR_CLIENT_SECRET',
        },
      );
      return response.data['access_token'];
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }
}
