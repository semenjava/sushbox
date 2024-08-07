import 'package:flutter/material.dart';
import 'package:sushibox/utill/dimensions.dart';
import 'package:sushibox/utill/styles.dart';

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Function onTap;
  const ProfileButton(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 20),
            Text(title!,
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge))
          ],
        ),
      ),
    );
  }
}
