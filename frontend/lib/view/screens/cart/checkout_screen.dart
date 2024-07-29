import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:sushibox/data/datasource/remote/dio/dio_client.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:sushibox/localization/language_constrants.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _showRegistrationForm = false;
  late DioClient dioClient;
  String? _userName;
  String? _userPhone;

  @override
  void initState() {
    super.initState();
    _initializeDioClient();
    retrieveLocation();
    _checkUserStatus();
  }

  void _initializeDioClient() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dioClient = DioClient(
      AppConstants.baseUrl,
      null,
      loggingInterceptor: LoggingInterceptor(),
      sharedPreferences: sharedPreferences,
    );
  }

  void retrieveLocation() async {
    try {
      currentLocation = await location.getLocation();
      LatLng myLocation =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: myLocation,
        zoom: 14.0,
      )));
    } catch (e) {
      _showErrorDialog('Location Error', 'Unable to retrieve location.');
    }
  }

  Set<Marker> _createMarkers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('sushibox_location'),
        position: LatLng(40.54957, 22.95545),
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
          LatLng(40.4000, 22.8000),
          LatLng(40.7000, 22.8000),
          LatLng(40.7000, 23.2000),
          LatLng(40.4000, 23.2000),
        ],
        strokeColor: Colors.blueAccent,
        strokeWidth: 2,
        fillColor: Colors.blueAccent.withOpacity(0.1),
      ),
    ].toSet();
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
            if (_userName != null && _userPhone != null) ...[
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
                      child: Text(getTranslated('login', context)!),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showRegistrationForm = true;
                        });
                      },
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
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.54957, 22.95545),
                  zoom: 14.0,
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
                    decoration: InputDecoration(
                      labelText: getTranslated('enter_address', context),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _placeOrder();
              },
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
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: getTranslated('otp', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _loginUser();
            },
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
            'Login Error', data['message'] ?? 'Unknown error occurred');
      }
    } on DioException catch (e) {
      _showErrorDialog('Login Error', _getDioErrorMessage(e));
    } catch (e) {
      _showErrorDialog('Login Error', 'An unexpected error occurred');
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

  String _getDioErrorMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return 'Bad Request: ${e.response?.data['message'] ?? 'Invalid input'}';
      case 401:
        return 'Unauthorized: ${e.response?.data['message'] ?? 'Invalid credentials'}';
      case 403:
        return 'Forbidden: ${e.response?.data['message'] ?? 'Access denied'}';
      case 404:
        return 'Not Found: ${e.response?.data['message'] ?? 'Resource not found'}';
      case 500:
        return 'Server Error: ${e.response?.data['message'] ?? 'An error occurred on the server'}';
      default:
        return 'Unexpected Error: ${e.response?.data['message'] ?? 'An unexpected error occurred'}';
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

  Future<void> _placeOrder() async {
    try {
      final response = await dioClient.post(
        '/api/v1/orders',
        data: {
          'address': 'Some address',
          'items': widget.cartItems.map((item) => item.toJson()).toList(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!')),
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

  void _checkUserStatus() async {
    bool isLoggedIn = await _isUserLoggedIn();
    if (isLoggedIn) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userName = prefs.getString('user_name');
        _userPhone = prefs.getString('user_phone');
      });
    } else {
      setState(() {
        _showRegistrationForm = true;
      });
    }
  }

  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return token != null;
  }
}
