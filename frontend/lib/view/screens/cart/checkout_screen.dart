import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'
    as loc; // Используем алиас 'loc' для пакета 'location'
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart'; // Библиотека геокодирования
import 'package:sushibox/data/datasource/remote/dio/dio_client.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/helper/vivapayments_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late GoogleMapController mapController;
  loc.LocationData? currentLocation;
  loc.Location location = loc.Location();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _showRegistrationForm = false;
  late DioClient dioClient;
  String? _userName;
  String? _userPhone;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _initializeDioClient();
    _checkUserStatus();
  }

  bool _isDioClientInitialized = false;

  Future<void> _initializeDioClient() async {
    if (!_isDioClientInitialized) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      dioClient = DioClient(
        AppConstants.baseUrl,
        null,
        loggingInterceptor: LoggingInterceptor(),
        sharedPreferences: sharedPreferences,
      );
      _isDioClientInitialized = true;
    }
  }

  void retrieveLocation() async {
    if (mapController != null) {
      LatLng myLocation = LatLng(40.54493989162326, 23.019136095415625);
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLocation,
            zoom: 10.0,
          ),
        ),
      );
    }
  }

  Set<Marker> _createMarkers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('sushibox_location'),
        position: LatLng(40.54493989162326, 23.019136095415625),
        infoWindow: InfoWindow(
          title: 'Sushibox',
          snippet: 'Vasilikis Tavaki 19, Thermi 570 01',
        ),
      ),
    ].toSet();
  }

  Set<Polygon> _createDeliveryArea() {
    return <Polygon>[
      Polygon(
        polygonId: PolygonId('delivery_area'),
        points: [
          LatLng(40.38723971587955, 22.932063655835154),
          LatLng(40.42906936110138, 23.13722082110204),
          LatLng(40.50761085928984, 23.163318013430125),
          LatLng(40.56291131350894, 23.193874135083203),
          LatLng(40.60298287782069, 23.106286219213843),
          LatLng(40.64593490990889, 23.043959410103497),
          LatLng(40.7464276743957, 22.962093108815314),
          LatLng(40.736919485385215, 22.76118901165113),
          LatLng(40.631589771097005, 22.83160282539366),
          LatLng(40.63111441147806, 22.933156191086347),
          LatLng(40.593193896348815, 22.945717400746226),
          LatLng(40.58354263017218, 22.933156409842464),
          LatLng(40.55104495563535, 22.974876966782894),
          LatLng(40.502815334348206, 22.81489444567794),
          LatLng(40.47785616674641, 22.811734943099623),
          LatLng(40.37868658243907, 22.894203897435805),
        ],
        strokeColor: Colors.blueAccent,
        strokeWidth: 2,
        fillColor: Colors.blueAccent.withOpacity(0.1),
      ),
    ].toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    retrieveLocation(); // Обновите положение камеры после инициализации карты
  }

  Future<void> _handleMapTap(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';

        setState(() {
          addressController.text = address;
        });
      } else {
        setState(() {
          addressController.text = 'Address not found';
        });
      }
    } catch (e) {
      setState(() {
        addressController.text = 'Error fetching address';
      });
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in widget.cartItems) {
      totalPrice += item.product.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('checkout', context)!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_authToken != null &&
                _userName != null &&
                _userPhone != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $_userName!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Phone: $_userPhone',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showRegistrationForm = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC6A87D),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(getTranslated('login', context)!),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showRegistrationForm = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC6A87D),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(getTranslated('register', context)!),
                    ),
                  ],
                ),
              ),
              _showRegistrationForm
                  ? _buildRegistrationForm()
                  : _buildLoginForm(),
            ],
            Container(
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _handleMapTap, // Добавляем обработчик нажатий
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.54493989162326, 23.019136095415625),
                  zoom: 10.0,
                ),
                markers: _createMarkers(),
                polygons: _createDeliveryArea(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getTranslated('delivery_address', context)!),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: getTranslated('enter_address', context),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${getTranslated('total', context)}: ${getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _placeOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC6A87D),
                foregroundColor: Colors.white,
              ),
              child: Text(getTranslated('place_order', context)!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('login', context)!,
              style: TextStyle(fontSize: 18)),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: getTranslated('phone', context),
              border: OutlineInputBorder(),
            ),
            keyboardType:
                TextInputType.phone, // Телефонное поле с цифровой клавиатурой
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: getTranslated('otp',
                  context), // Или "password", если это действительно пароль
              border: OutlineInputBorder(),
            ),
            keyboardType:
                TextInputType.text, // Стандартная клавиатура для ввода текста
            obscureText: true, // Скрытие символов при вводе
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _loginUser();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC6A87D),
              foregroundColor: Colors.white,
            ),
            child: Text(getTranslated('login', context)!),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getTranslated('register', context)!,
              style: TextStyle(fontSize: 18)),
          TextField(
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: getTranslated('first_name', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
          ),
          TextField(
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: getTranslated('last_name', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: getTranslated('email', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: getTranslated('password', context),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: getTranslated('phone', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _registerUser();
            },
            child: Text(getTranslated('register', context)!),
          ),
        ],
      ),
    );
  }

  Future<void> _loginUser() async {
    try {
      final response = await dioClient.post(
        '/api/v1/auth/login',
        data: {
          'phone': phoneController.text,
          'password': passController.text,
        },
      );
      print("!!! Login successful ${response}");
      if (response.statusCode == 200) {
        var data = response.data;
        String token = data['token'];
        String name = data['user']['name'];
        String phone = data['user']['phone'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', name);
        await prefs.setString('user_phone', phone);

        setState(() {
          _authToken = token; // Обновляем токен в состоянии
          _userName = name;
          _userPhone = phone;
          _showRegistrationForm = false;
        });
      } else {
        var data = response.data;
        _showErrorSnackbar(data['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to login');
    }
  }

  Future<void> _registerUser() async {
    try {
      final response = await dioClient.post(
        '/api/v1/auth/registration',
        data: {
          'f_name': firstNameController.text,
          'l_name': lastNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var data = response.data;
        String token = data['token'];
        String name = data['user']['name'];
        String phone = data['user']['phone'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_name', name);
        await prefs.setString('user_phone', phone);

        setState(() {
          _userName = name;
          _userPhone = phone;
          _showRegistrationForm = false;
        });
      } else {
        var data = response.data;
        _showErrorDialog(
            'Registration Error', data['message'] ?? 'Unknown error occurred');
      }
    } on DioException catch (e) {
      _showErrorDialog('Registration Error', _getDioErrorMessage(e));
    } catch (e) {
      _showErrorDialog('Registration Error', 'An unexpected error occurred');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  Future<void> _checkUserStatus() async {
    bool isLoggedIn = await _isUserLoggedIn();

    if (isLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('user_name');
        _userPhone = prefs.getString('user_phone');
        _showRegistrationForm =
            false; // Скрываем формы, если пользователь авторизован
      });
    } else {
      setState(() {
        _showRegistrationForm =
            true; // Показываем формы, если пользователь не авторизован
      });
    }
  }

  Future<void> _placeOrder() async {
    await _initializeDioClient();

    String address = addressController.text;

    if (address.isEmpty) {
      _showErrorSnackbar('Please enter a delivery address');
      return;
    }

    try {
      final response = await dioClient.post(
        '/api/v1//customer/order/payment/place',
        data: {
          'address': address,
          'items': widget.cartItems.map((item) => item.toJson()).toList(),
        },
      );

      if (response.statusCode == 200) {
        var data = response.data;
        String redirectUrl = data['redirect_url'];

        if (await canLaunch(redirectUrl)) {
          await launch(
            redirectUrl,
            forceWebView: false, // Попробуйте принудительное открытие в WebView
            forceSafariVC: false, // Для iOS
          );
        } else {
          throw 'Could not launch $redirectUrl';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Order placed successfully! Redirecting to payment...')),
        );
      } else {
        var data = response.data;
        _showErrorDialog(
            'Order Error', data['message'] ?? 'Unknown error occurred');
      }
    } on DioException catch (e) {
      _showErrorDialog('Order Error', _getDioErrorMessage(e));
    } catch (e) {
      _showErrorDialog('Order Error', 'An unexpected error occurred');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return token != null;
  }
}
