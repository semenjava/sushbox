import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/data/model/response/product_model.dart';
import 'package:sushibox/data/model/response/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushibox/view/screens/cart/checkout_screen.dart';
import 'package:sushibox/utill/app_constants.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cartJson = prefs.getString('cart');

      if (cartJson != null) {
        List<dynamic> decodedJson = jsonDecode(cartJson);
        List<CartItem> loadedItems =
            decodedJson.map((item) => CartItem.fromJson(item)).toList();

        setState(() {
          cartItems = loadedItems;
        });
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
  }

  void updateCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'cart', jsonEncode(cartItems.map((item) => item.toJson()).toList()));
    } catch (e) {
      print('Error updating cart: $e');
    }
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.product.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated('cart', context)!,
          style: TextStyle(
              color: Colors.white), // устанавливаем белый цвет текста в AppBar
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                getTranslated('cart_empty', context)!,
                style: TextStyle(
                    color: Colors.white), // устанавливаем белый цвет текста
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      CartItem cartItem = cartItems[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${AppConstants.baseUrl}${cartItem.product.image}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            cartItem.product.name,
                            style: TextStyle(
                                color: Colors
                                    .white), // устанавливаем белый цвет текста
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${getTranslated('price', context)}: ${cartItem.product.price}',
                                style: TextStyle(
                                    color: Colors
                                        .white), // устанавливаем белый цвет текста
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (cartItem.quantity > 1) {
                                          cartItem.quantity--;
                                        } else {
                                          cartItems.removeAt(index);
                                        }
                                      });
                                      updateCart();
                                    },
                                    color: Colors
                                        .white, // устанавливаем белый цвет иконки
                                  ),
                                  Text(
                                    cartItem.quantity.toString(),
                                    style: TextStyle(
                                        color: Colors
                                            .white), // устанавливаем белый цвет текста
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        cartItem.quantity++;
                                      });
                                      updateCart();
                                    },
                                    color: Colors
                                        .white, // устанавливаем белый цвет иконки
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                              updateCart();
                            },
                            color:
                                Colors.white, // устанавливаем белый цвет иконки
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${getTranslated('total', context)}: ${getTotalPrice().toStringAsFixed(2)}', // Отображаем общую цену с двумя знаками после запятой
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              Colors.white, // устанавливаем белый цвет текста
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutScreen(cartItems: cartItems),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xFFC6A87D), // устанавливаем цвет кнопки
                          ),
                        ),
                        child: Text(
                          getTranslated('checkout', context)!,
                          style: TextStyle(
                              color: Colors
                                  .white), // устанавливаем белый цвет текста
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearCart();
        },
        child: Icon(Icons.delete_forever),
        tooltip: getTranslated('clear_cart', context),
        backgroundColor: Color(0xFFC6A87D), // устанавливаем цвет заливки кнопки
        foregroundColor: Colors.white, // устанавливаем белый цвет иконки
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Изменение расположения кнопок действия
    );
  }

  void clearCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart');
      setState(() {
        cartItems.clear();
      });
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
