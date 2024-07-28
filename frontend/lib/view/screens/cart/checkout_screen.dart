import 'package:flutter/material.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/view/screens/cart/cart_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  TextEditingController otpController = TextEditingController();
  bool _showRegistrationForm = false;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    currentLocation = await location.getLocation();
    LatLng myLocation =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: myLocation,
      zoom: 14.0,
    )));
  }

  Set<Marker> _createMarkers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('sushibox_location'),
        position: LatLng(40.54957, 22.95545), // Координаты Sushibox
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
                // Обработчик оформления заказа
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
            controller: otpController,
            decoration: InputDecoration(
              labelText: getTranslated('otp', context),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Обработчик для входа
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
              // Обработчик для регистрации
              _registerUser();
            },
            child: Text(getTranslated('register', context)!),
          ),
        ],
      ),
    );
  }

  void _loginUser() async {
    var url = Uri.parse('http://your_api_url/auth/login');
    var response = await http.post(url, body: {
      'phone': phoneController.text,
      'otp': otpController.text,
    });

    if (response.statusCode == 200) {
      // Обработка успешного входа
      var data = jsonDecode(response.body);
      // Сохранение токена или пользователя в shared_preferences или другой системе хранения
    } else {
      // Обработка ошибок входа
      var data = jsonDecode(response.body);
      // Показать сообщение об ошибке
    }
  }

  void _registerUser() async {
    var url = Uri.parse('http://your_api_url/auth/registration');
    var response = await http.post(url, body: {
      'f_name': firstNameController.text,
      'l_name': lastNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      // Обработка успешной регистрации
      var data = jsonDecode(response.body);
      // Сохранение токена или пользователя в shared_preferences или другой системе хранения
    } else {
      // Обработка ошибок регистрации
      var data = jsonDecode(response.body);
      // Показать сообщение об ошибке
    }
  }

  void _placeOrder() {
    // Логика для оформления заказа
  }
}
