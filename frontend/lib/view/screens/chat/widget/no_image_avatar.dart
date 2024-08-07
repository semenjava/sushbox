import 'package:flutter/material.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/utill/images.dart';

class NoImageAvatar extends StatelessWidget {
  const NoImageAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Dimensions.paddingSizeDefault,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.asset(Images.placeholderUser),
      ),
    );
  }
}
