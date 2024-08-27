import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/view/screens/home/home_screen.dart';
import 'package:sushibox/view/screens/order/order_history_screen.dart';
import 'package:sushibox/view/screens/profile/profile_screen.dart';
import 'package:sushibox/view/screens/product/product_list_screen.dart';
import 'package:sushibox/view/screens/category/category_list_screen.dart'; // Импорт CategoryListScreen
import 'package:sushibox/provider/home_provider.dart';
import 'package:sushibox/provider/customer_provider.dart';
import 'package:sushibox/view/screens/auth/login_screen.dart';
import 'package:sushibox/view/screens/cart/cart_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sushibox/utill/app_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild the screens if the authentication status changes
    final customerProvider = Provider.of<CustomerProvider>(context);
    if (customerProvider.isAuthenticated && _screens.length < 4) {
      _updateScreens();
    }

    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _screens[index];
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0), // Отступы вокруг кнопки
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Закругление углов
                child: Container(
                  color: Color(0xFFC6A87D), // Цвет фона кнопки
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CartScreen(),
                      ));
                    },
                    icon: SvgPicture.network(
                      '${AppConstants.baseUrl}/assets/img/cart.svg', // URL вашей иконки корзины в формате SVG
                      width: 24,
                      height: 24,
                      color: Colors.white, // Цвет иконки
                    ),
                    label: Text(
                      getTranslated('cart', context)!, // Текст кнопки
                      style: TextStyle(color: Colors.white), // Цвет текста
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Фон кнопки будет задан через контейнер
                      foregroundColor: Colors.white, // Цвет текста
                      padding: EdgeInsets.all(16.0), // Отступы внутри кнопки
                      minimumSize: Size(
                          double.infinity, 48), // Минимальный размер кнопки
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: BottomNavigationBar(
                selectedItemColor: Colors.white, // Цвет для выбранной иконки
                unselectedItemColor: Colors.white
                    .withOpacity(0.7), // Цвет для невыбранных иконок
                backgroundColor:
                    Color.fromARGB(255, 12, 11, 10), // Цвет фона нижнего меню
                showUnselectedLabels: true,
                currentIndex: _pageIndex,
                type: BottomNavigationBarType.fixed,
                items: [
                  _barItem(Icons.home, getTranslated('home', context), 0),
                  _barItem(Icons.store, getTranslated('store', context), 1),
                  _barItem(Icons.person, getTranslated('profile', context), 2),
                ],
                onTap: (int index) {
                  _setPage(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon,
          color: index == _pageIndex
              ? Theme.of(context).primaryColor
              : Theme.of(context).hintColor.withOpacity(0.7),
          size: 20),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  void _updateScreens() {
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    _screens = [
      HomeScreen(),
      CategoryListScreen(),
      if (customerProvider.isAuthenticated) ProfileScreen() else LoginScreen(),
    ];
  }
}
