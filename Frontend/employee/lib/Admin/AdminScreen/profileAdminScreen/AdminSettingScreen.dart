import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import '../../../Widgets/setting widget/SettingWidget.dart';
import '../../../screens/Login/LoginScreen.dart';
import '../../../services/services.dart';

import '../AdminHome.dart';

import 'AdminChangePassword.dart';
import 'UpdateProfile.dart';




class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreen();

}

class _AdminSettingsScreen extends State<AdminSettingsScreen> {

  void _logout() async {

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
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
            },
          ),
              const SizedBox(height: 40),
              SettingsTile(
                color: Colors.blue,
                icon: Ionicons.person_circle_outline,
                title: "Account & Security",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminChangePassword()));

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUpdateProfile()));
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