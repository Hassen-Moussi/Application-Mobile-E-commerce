import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
class Login_button extends StatelessWidget {
  const Login_button({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAllNamed(Croutes.phone);
      },
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
            MaterialStateProperty.all<Color>(Color.fromARGB(255, 38, 23, 174)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: Text(
          'Login Here',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}