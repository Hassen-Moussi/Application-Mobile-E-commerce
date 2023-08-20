import 'package:banking_app/Controller/TranslationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';


import '../../Provider/LangugeProv.dart';
import '../../Services/service.dart';
import '../../routes/routes.dart';
import '../../widgets/SettingWidget.dart';
import '../ProfileManagementScreens/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {


  void _logout() async {
    // Clear the data from storage


    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SettingsTile(
                color: Colors.blue,
                icon: Ionicons.person_circle_outline,
                title: "Account & Security",
                onTap: () {
                  Get.offAndToNamed(Croutes.changeP);

                },
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: Colors.green,
                icon: Ionicons.pencil_outline,
                title: "Edit Information",
                onTap: () {
                  Get.offAndToNamed(Croutes.update);
                },
              ),
              const SizedBox(
                height: 40,
              ),
              SettingsTile(
                color: Colors.black,
                icon: Ionicons.moon_outline,
                title: "Theme",
                onTap: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              SettingsTile(
                color: Colors.purple,
                icon: Ionicons.language_outline,
                title: "Language",


                  onTap: () {

                  }





              ),
              const SizedBox(
                height: 40,
              ),
              SettingsTile(
                color: Colors.red,
                icon: Ionicons.log_out_outline,
                title: "Logout",
                onTap: () {
                  setState(() {
                    _logout();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}