import 'package:dio/dio.dart';
import 'package:sushibox/data/repository/auth_repo.dart';
import 'package:sushibox/data/repository/chat_repo.dart';
import 'package:sushibox/data/repository/language_repo.dart';
import 'package:sushibox/data/repository/order_repo.dart';
import 'package:sushibox/data/repository/profile_repo.dart';
import 'package:sushibox/data/repository/splash_repo.dart';
import 'package:sushibox/data/repository/tracker_repo.dart';
import 'package:sushibox/data/repository/banner_repo.dart';
import 'package:sushibox/data/repository/home_repo.dart';
import 'package:sushibox/data/repository/products_latest_repo.dart';
import 'package:sushibox/data/repository/product_repo.dart';
import 'package:sushibox/provider/auth_provider.dart';
import 'package:sushibox/provider/chat_provider.dart';
import 'package:sushibox/provider/localization_provider.dart';
import 'package:sushibox/provider/language_provider.dart';
import 'package:sushibox/provider/order_provider.dart';
import 'package:sushibox/provider/profile_provider.dart';
import 'package:sushibox/provider/splash_provider.dart';
import 'package:sushibox/provider/theme_provider.dart';
import 'package:sushibox/provider/time_provider.dart';
import 'package:sushibox/provider/tracker_provider.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'package:sushibox/provider/banner_provider.dart';
import 'package:sushibox/provider/home_provider.dart';
import 'package:sushibox/provider/products_latest_provider.dart';
import 'package:sushibox/data/repository/cart_repo.dart';
import 'package:sushibox/provider/cart_provider.dart';
import 'package:sushibox/provider/product_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(
      () => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => OrderRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => TrackerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ChatRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => BannerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => HomeRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProductsLatestRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => ProductRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(
      () => CartRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(
      () => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl()));
  sl.registerFactory(() => TrackerProvider(trackerRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl()));
  sl.registerFactory(() => TimerProvider());
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => HomeProvider(homeRepo: sl()));
  sl.registerFactory(() => ProductsLatestProvider(productsLatestRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
