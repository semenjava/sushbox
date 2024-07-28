import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sushibox/provider/localization_provider.dart';
import 'package:sushibox/utill/app_constants.dart';
import 'package:sushibox/utill/styles.dart';
import 'package:sushibox/provider/auth_provider.dart';
import 'package:sushibox/provider/splash_provider.dart';
import 'package:sushibox/utill/images.dart';
import 'package:sushibox/view/screens/auth/login_screen.dart';
import 'package:sushibox/view/screens/dashboard/dashboard_screen.dart';
import 'package:sushibox/view/screens/language/choose_language_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()));

          // if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
          //   Provider.of<AuthProvider>(context, listen: false).updateToken();
          //   Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const DashboardScreen()));
          // } else if (Provider.of<LocalizationProvider>(context, listen: false).getLanguageCode() == '') {
          //   Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const ChooseLanguageScreen()));
          // } else {
          //   Navigator.pushReplacement(context,MaterialPageRoute(builder: (_) => const LoginScreen()));
          // }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(Images.logo, width: 150)),
            const SizedBox(height: 20),
            Text(AppConstants.appName,
                style: rubikBold.copyWith(
                    fontSize: 30, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
