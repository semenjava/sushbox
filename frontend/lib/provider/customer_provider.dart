import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushibox/data/datasource/remote/dio/dio_client.dart';
import 'package:sushibox/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:sushibox/utill/app_constants.dart';

class Customer {
  final String name;
  final String email;
  final String phone;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class CustomerProvider with ChangeNotifier {
  Customer? _customer;
  String? _token;
  bool _isAuthenticated = false;
  late DioClient dioClient;

  bool get isAuthenticated => _isAuthenticated;
  Customer? get customer => _customer;

  CustomerProvider() {
    _initializeDioClient();
  }

  Future<void> _initializeDioClient() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dioClient = DioClient(
      AppConstants.baseUrl,
      null,
      loggingInterceptor: LoggingInterceptor(),
      sharedPreferences: sharedPreferences,
    );

    // Обновить заголовки после инициализации
    dioClient.updateHeader();
  }

  Future<void> login(String phone, String password) async {
    try {
      final response = await dioClient.post(
        '/api/v1/auth/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _token = data['token'];
        _isAuthenticated = true;

        dioClient.updateHeader(getToken: _token);

        await _fetchCustomerData();
        notifyListeners();
        await _saveUserData();
      } else {
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      throw Exception('Failed to login: ${_getDioErrorMessage(e)}');
    }
  }

  Future<String?> register(String f_name, String l_name, String email,
      String phone, String password) async {
    try {
      final response = await dioClient.post(
        '/api/v1/auth/registration',
        data: {
          'f_name': f_name,
          'l_name': l_name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        _token = data['token'];
        _isAuthenticated = true;

        dioClient.updateHeader(getToken: _token);

        await _fetchCustomerData();
        notifyListeners();
        await _saveUserData();
        return null;
      } else {
        return 'Failed to register';
      }
    } on DioException catch (e) {
      return _getDioErrorMessage(e);
    }
  }

  Future<void> _fetchCustomerData() async {
    if (_token == null) return;

    try {
      final response = await dioClient.get(
        '/api/v1/customer/info',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _customer = Customer(
          name: data['f_name'] + ' ' + data['l_name'],
          email: data['email'],
          phone: data['phone'],
        );
      } else {
        throw Exception('Failed to load customer data');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to load customer data: ${_getDioErrorMessage(e)}');
    }
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    if (_token == null) return;

    try {
      final response = await dioClient.put(
        '/api/v1/auth/profile',
        data: {
          'name': updatedCustomer.name,
          'email': updatedCustomer.email,
          'phone': updatedCustomer.phone,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _customer = Customer(
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
        );
        notifyListeners();
      } else {
        throw Exception('Failed to update customer data');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to update customer data: ${_getDioErrorMessage(e)}');
    }
  }

  Future<void> logout() async {
    if (_token == null) return;

    try {
      final response = await dioClient.post('/api/v1/customer/logout');

      if (response.statusCode == 200) {
        _token = null;
        _customer = null;
        _isAuthenticated = false;
        await _clearUserData();
        notifyListeners();
      } else {
        throw Exception('Failed to logout');
      }
    } on DioException catch (e) {
      throw Exception('Failed to logout: ${_getDioErrorMessage(e)}');
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token ?? '');
    await prefs.setString('user_name', _customer?.name ?? '');
    await prefs.setString('user_email', _customer?.email ?? '');
    await prefs.setString('user_phone', _customer?.phone ?? '');
  }

  Future<void> _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
  }

  String _getDioErrorMessage(DioException e) {
    if (e.response != null && e.response?.data != null) {
      if (e.response!.data['errors'] != null) {
        return (e.response!.data['errors'] as List)
            .map((err) => err['message'])
            .join('\n');
      } else if (e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    switch (e.response?.statusCode) {
      case 400:
        return 'Bad Request: Invalid input';
      case 401:
        return 'Unauthorized: Invalid credentials';
      case 403:
        return 'Forbidden: Access denied';
      case 404:
        return 'Not Found: Resource not found';
      case 500:
        return 'Server Error: An error occurred on the server';
      default:
        return 'Unexpected Error: ${e.message}';
    }
  }
}
