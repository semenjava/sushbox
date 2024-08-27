import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

class PaymentCallbackHandler extends StatefulWidget {
  @override
  _PaymentCallbackHandlerState createState() => _PaymentCallbackHandlerState();
}

class _PaymentCallbackHandlerState extends State<PaymentCallbackHandler> {
  @override
  void initState() {
    super.initState();
    _initUniLinks();
  }

  void _initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handlePaymentCallback(initialLink);
      }
      linkStream.listen((String? link) {
        if (link != null) {
          _handlePaymentCallback(link);
        }
      });
    } catch (e) {
      print('Error handling link: $e');
    }
  }

  void _handlePaymentCallback(String link) {
    // Обработка ссылки и проверка статуса платежа
    print('Payment callback link: $link');
    // Здесь вы можете проверить статус платежа, используя API или другой механизм
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Callback Handler'),
      ),
      body: Center(
        child: Text('Waiting for payment callback...'),
      ),
    );
  }
}
