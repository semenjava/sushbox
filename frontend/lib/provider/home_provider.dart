import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:sushibox/data/model/response/category_model.dart';
import 'package:sushibox/data/model/response/item_model.dart';
import 'package:sushibox/data/repository/home_repo.dart';
import 'package:sushibox/helper/api_checker.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepo homeRepo;

  HomeProvider({required this.homeRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  Future<void> getCategoryList(BuildContext context) async {
    ApiResponse apiResponse = await homeRepo.getCategoryList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      try {
        _categoryList = (apiResponse.response!.data as List)
            .map((categoryList) => CategoryModel.fromJson(categoryList))
            .toList();

        // _categoryList =
        //     CategoryModel.fromJson(apiResponse.response!.data).categories;
      } catch (e) {
        print('Error parsing category list: $e');
      }
    } else {
      // Handle error
      print('Failed to fetch category list');
    }
    notifyListeners();
  }

  Future<void> refreshCategory(BuildContext context) async {
    await getCategoryList(context);
  }
}
