import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:sushibox/data/repository/cart_repo.dart';
import 'package:sushibox/helper/api_checker.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;

  CartProvider({required this.cartRepo});

  List<CartModel>? _cartList;
  List<CartModel>? get cartList => _cartList;

  Future<void> getCartList(BuildContext context) async {
    ApiResponse apiResponse = await cartRepo.getCartList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      try {
        _cartList = (apiResponse.response!.data as List)
            .map((cartJson) => CartModel.fromJson(cartJson))
            .toList();
      } catch (e) {
        print('Error parsing cart list: $e');
      }
    } else {
      // Handle error
      print('Failed to fetch cart list');
    }
    notifyListeners();
  }

  Future<void> refresh(BuildContext context) async {
    await getCartList(context);
  }
}
