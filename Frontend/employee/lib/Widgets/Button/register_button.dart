import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/routes.dart';
class Register_Button extends StatelessWidget {
  const Register_Button({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAllNamed(Croutes.register);
      },
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(Colors.purple),
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}