import 'dart:ui';

import 'package:get/get.dart';


class TranslationController extends GetxController {
  final _locale = Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  set locale(Locale value) {
    _locale.value = value;
    Get.updateLocale(value);
  }

  List<Locale> get supportedLocales => [
    Locale('en', 'US'),
    Locale('es', 'ES'),
  ];

  void changeLocale(Locale value) {
    locale = value;
  }
}