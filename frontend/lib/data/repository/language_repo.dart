import 'package:flutter/material.dart';
import 'package:sushibox/data/model/response/language_model.dart';
import 'package:sushibox/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }
}
