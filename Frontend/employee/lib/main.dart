
import 'package:dyno_mvp/routes/pages.dart';
import 'package:dyno_mvp/screens/Login/LoginScreen.dart';
import 'package:dyno_mvp/screens/splash_screen/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized;
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
        primaryColor: Colors.blue.shade300

      ),
      getPages:Cpages.getPages,

      home:   Splash(),
    );
  }
}

