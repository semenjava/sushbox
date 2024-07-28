import 'package:dio/dio.dart';
import 'package:sushibox/data/datasource/remote/dio/dio_client.dart';
import 'package:sushibox/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';
import 'package:sushibox/data/model/response/product_model.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProductRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getProductList(String categoryId) async {
    try {
      final response =
          await dioClient!.get('${AppConstants.productListUri}$categoryId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
