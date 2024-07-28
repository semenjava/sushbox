import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/product_model.dart';
import 'package:sushibox/data/repository/product_repo.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({required this.productRepo});

  List<Product>? _productList;
  List<Product>? get productList => _productList;

  String? _currentCategoryId;
  String? get currentCategoryId => _currentCategoryId;

  Future<void> getProductList(String categoryId, BuildContext context) async {
    _currentCategoryId = categoryId;
    ApiResponse apiResponse = await productRepo.getProductList(categoryId);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _productList = ProductModel.fromJson(apiResponse.response!.data).products;
    } else {
      print('Failed to fetch products list');
    }
    notifyListeners();
  }

  Future<void> refresh(BuildContext context) async {
    if (_currentCategoryId != null) {
      await getProductList(_currentCategoryId!, context);
    }
  }
}
