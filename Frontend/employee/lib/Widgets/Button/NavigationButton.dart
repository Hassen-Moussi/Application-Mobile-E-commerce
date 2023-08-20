import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ButtonWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback callback;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: callback,
          child: Icon(icon),
          style: OutlinedButton.styleFrom(
            shape: CircleBorder(),
            side: BorderSide(color: Colors.blueGrey),
            padding: EdgeInsets.all(16),
            elevation: 5,
            backgroundColor: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.5),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
