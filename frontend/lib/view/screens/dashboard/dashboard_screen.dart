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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).hintColor.withOpacity(0.7),
          backgroundColor: Theme.of(context).cardColor,
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
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
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
