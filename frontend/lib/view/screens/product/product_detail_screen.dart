import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Добавьте этот импорт для работы с SVG
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/data/model/response/product_model.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/view/screens/cart/cart_screen.dart'; // Убедитесь, что импортируете ваш экран корзины

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => CartScreen(),
              ));
            },
            icon: SvgPicture.network(
              '${AppConstants.baseUrl}/assets/img/cart.svg', // URL вашей иконки корзины в формате SVG
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              '${AppConstants.baseUrl}${product.image}',
              fit: BoxFit.cover,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${getTranslated('price', context)}: ${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        addToCart(context, product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC6A87D),
                        foregroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                              width: 8), // Расстояние между иконкой и текстом
                          Text(getTranslated('add_to_cart', context)!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToCart(BuildContext context, Product product) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cartJson = prefs.getString('cart');
      List<CartItem> cartItems = [];

      if (cartJson != null) {
        List<dynamic> decodedJson = jsonDecode(cartJson);
        cartItems = decodedJson.map((item) => CartItem.fromJson(item)).toList();
      }

      bool productExists = false;
      for (var item in cartItems) {
        if (item.product.id == product.id) {
          item.quantity++;
          productExists = true;
          break;
        }
      }

      if (!productExists) {
        cartItems.add(CartItem(product: product));
      }

      await prefs.setString(
          'cart', jsonEncode(cartItems.map((item) => item.toJson()).toList()));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${getTranslated('product_added', context)}'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }
}
