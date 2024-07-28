import 'package:dio/dio.dart';
import 'package:sushibox/data/model/body/track_body.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/data/datasource/remote/dio/dio_client.dart';
import 'package:sushibox/data/datasource/remote/exception/api_error_handler.dart';
import 'package:sushibox/data/model/response/base/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  TrackerRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> addTrack(double lat, double long, String location) async {
    try {
      TrackBody trackBody = TrackBody(
        orderId: sharedPreferences!.getInt(AppConstants.orderId).toString(),
        token: sharedPreferences!.getString(AppConstants.token),
        latitude: lat,
        longitude: long,
        location: location,
      );
      Response response = await dioClient!
          .post(AppConstants.recordLocationUri, data: trackBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> setOrderID(int orderID) async {
    return await sharedPreferences!.setInt(AppConstants.orderId, orderID);
  }
}
