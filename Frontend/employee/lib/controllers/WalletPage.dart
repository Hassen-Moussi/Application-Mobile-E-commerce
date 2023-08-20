import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../Widgets/Button/NavigationButton.dart';
import '../routes/routes.dart';
import '../services/services.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
   String _balance='';
  Future<void> _getData()async{
    dynamic value = await storage.read(key:'profilinfo');
    Map dataresponse = json.decode(value);
    setState(() {
      _balance=dataresponse['balance'].toString();

    });
  }
  @override
  SingleChildScrollView Wallet(BuildContext context) {
    setState(() {
      _getData();
    });
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height:40,
          ),
          Text(
            "Total Balence",
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Text(
            "${_balance} DT",
            style: GoogleFonts.poppins(
                fontSize: 40, fontWeight: FontWeight.bold, color:Colors.blueAccent),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonWidget(
                text: 'Scan',
                icon: Iconsax.scan,
                callback: () {
                  Get.offAllNamed(Croutes.qrpage);
                },
              ),
              ButtonWidget(
                text: 'Generate Qr code',
                icon: Iconsax.scan_barcode,
                callback: () {
                  Get.offAllNamed(Croutes.qrval);
                },
              ),
              ButtonWidget(
                text: 'Payout',
                icon: Iconsax.money_send,
                callback: () {},
              ),
              ButtonWidget(
                text: 'Top Up',
                icon: Iconsax.add,
                callback: () {},
              ),
            ],
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wallet(context);
  }


}