import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/order_model.dart';
import 'package:sushibox/helper/price_converter.dart';
import 'package:sushibox/localization/language_constrants.dart';
import 'package:sushibox/provider/auth_provider.dart';
import 'package:sushibox/provider/order_provider.dart';
import 'package:sushibox/provider/tracker_provider.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/utill/images.dart';
import 'package:sushibox/utill/styles.dart';
import 'package:sushibox/view/base/custom_button.dart';
import 'package:sushibox/view/screens/order/order_details_screen.dart';
import 'package:sushibox/view/screens/order/order_place_screen.dart';
import 'package:provider/provider.dart';

class DeliveryDialog extends StatelessWidget {
  final Function onTap;
  final OrderModel? orderModel;

  final double? totalPrice;

  const DeliveryDialog(
      {Key? key, required this.onTap, this.totalPrice, this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(Images.money),
                const SizedBox(height: 20),
                Center(
                    child: Text(
                  getTranslated('do_you_collect_money', context)!,
                  style: rubikRegular,
                )),
                const SizedBox(height: 20),
                Center(
                    child: Text(
                  PriceConverter.convertPrice(context, totalPrice),
                  style: rubikMedium.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 30),
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      btnTxt: getTranslated('no', context),
                      isShowBorder: true,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(
                                  orderModelItem: orderModel,
                                )));
                      },
                    )),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: Consumer<OrderProvider>(
                      builder: (context, order, child) {
                        return !order.isLoading
                            ? CustomButton(
                                btnTxt: getTranslated('yes', context),
                                onTap: () {
                                  Provider.of<TrackerProvider>(context,
                                          listen: false)
                                      .stopLocationService();
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .updateOrderStatus(
                                          token: Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserToken(),
                                          orderId: orderModel!.id,
                                          status: 'delivered')
                                      .then((value) {
                                    if (value.isSuccess) {
                                      order.updatePaymentStatus(
                                          token: Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserToken(),
                                          orderId: orderModel!.id,
                                          status: 'paid');
                                      Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .getAllOrders(context);

                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) => OrderPlaceScreen(
                                                  orderID: orderModel!.id
                                                      .toString())));
                                    }
                                  });
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)));
                      },
                    )),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -20,
              top: -20,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.clear,
                      size: Dimensions.paddingSizeLarge),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) =>
                            OrderDetailsScreen(orderModelItem: orderModel)));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
