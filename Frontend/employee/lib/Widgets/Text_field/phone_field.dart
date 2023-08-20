import 'package:flutter/material.dart';
class PhoneField extends StatelessWidget {
  const PhoneField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(10)),
        prefix: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '(+216)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        suffixIcon: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 32,
        ),
      ),
    );
  }
}