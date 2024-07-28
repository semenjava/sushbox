import 'package:flutter/material.dart';
import 'package:sushibox/main.dart';

void showCustomSnackBar(String message, {bool isError = true}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Text(message),
  ));
}
