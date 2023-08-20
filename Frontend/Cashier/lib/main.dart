import 'package:banking_app/screens/Onboarding_content/Onboarding_screen.dart';
import 'package:banking_app/screens/ProfileManagementScreens/login.dart';
import 'package:banking_app/screens/splash_screen/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';


import 'routes/pages.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primaryColor: Colors.blue.shade300
        primarySwatch: Colors.indigo,


      ),

      getPages:Cpages.getPages,
      home:  Splash(),
    );
  }
}
