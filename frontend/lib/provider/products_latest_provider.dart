import 'package:flutter/material.dart';
// import 'package:sushibox/data/model/response/item_model.dart';
import 'package:sushibox/data/repository/products_latest_repo.dart';
import 'package:sushibox/helper/api_checker.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';
import 'package:sushibox/data/model/response/product_model.dart';

class ProductsLatestProvider extends ChangeNotifier {
  final ProductsLatestRepo productsLatestRepo;

  ProductsLatestProvider({required this.productsLatestRepo});

  List<Product>? _productsLatest;
  List<Product>? get productsLatest => _productsLatest;

  Future<void> getProductsLatest(BuildContext context) async {
    ApiResponse apiResponse = await productsLatestRepo.getProductsLatest();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      try {
        // Извлекаем список продуктов из поля 'products' в JSON-ответе
        List<dynamic> productsData = apiResponse.response!.data['products'];
        _productsLatest = productsData
            .map((productData) => Product.fromJson(productData))
            .toList();
      } catch (e) {
        print('Error parsing products Latest list: $e');
      }
    } else {
      // Handle error
      print('Failed to fetch products Latest list');
    }
    notifyListeners();
  }

  Future<void> refreshProductsLatest(BuildContext context) async {
    await getProductsLatest(context);
  }
}
