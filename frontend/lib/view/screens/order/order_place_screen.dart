import 'package:flutter/material.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/utill/images.dart';
import 'package:sushibox/view/base/custom_button.dart';
import 'package:sushibox/view/screens/dashboard/dashboard_screen.dart';

class OrderPlaceScreen extends StatelessWidget {
  final String? orderID;

  const OrderPlaceScreen({Key? key, this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.doneWithFullBackground,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                'Order Successfully Delivered',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated('order_id', context)!,
                    style:
                        Theme.of(context).textTheme.displayMedium!.copyWith(),
                  ),
                  Text(
                    ' #$orderID',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomButton(
                btnTxt: getTranslated('back_home', context),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const DashboardScreen()),
                      (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
