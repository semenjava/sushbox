import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/banner_model.dart';
import 'package:sushibox/data/repository/banner_repo.dart';
import 'package:sushibox/helper/api_checker.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _bannerList;
  List<BannerModel>? get bannerList => _bannerList;

  Future<void> getBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getBannerList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      try {
        _bannerList = (apiResponse.response!.data as List)
            .map((bannerJson) => BannerModel.fromJson(bannerJson))
            .toList();
      } catch (e) {
        print('Error parsing banner list: $e');
      }
    } else {
      // Handle error
      print('Failed to fetch banner list');
    }
    notifyListeners();
  }

  Future<void> refresh(BuildContext context) async {
    await getBannerList(context);
  }
}
