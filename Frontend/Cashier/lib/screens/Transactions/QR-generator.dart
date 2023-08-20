import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Services/service.dart';
import '../../widgets/QrCode/QrCode.dart';




class MyQrGenPage extends StatefulWidget {
  @override
  _MyQrGenState createState() => _MyQrGenState();

}

class _MyQrGenState extends State<MyQrGenPage> {
  String idcashier = '';
  String productname = '';
  String productval = '';
  String id = '';
  bool _showQRCode = true;
  late int remainingSeconds;

  Future<void> _getData() async {
    dynamic cashierid = await storage.read(key: 'idvalue');
    dynamic value = await storage.read(key: 'productvalue');
    dynamic value1 = await storage.read(key: 'productname');
    dynamic transactionid = await storage.read(key: 'transactionid');
    setState(() {
      idcashier = cashierid;
      productval = value;
      productname = value1;
      id = transactionid;
    });
  }


  @override
  void initState() {
    super.initState();
    remainingSeconds = 20;
    _getData().then((value) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          remainingSeconds--;
        });
        if (remainingSeconds == 0) {
          timer.cancel();
          setState(() {
            _showQRCode = false;
          });
          Get.back();
          Get.snackbar('Time Out', 'Check Transaction history');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _showQRCode ? QrCode(value1: id, value2: idcashier) : Container(),
            SizedBox(height: 20),
            Text('Remaining Time: ${remainingSeconds}s'),
          ],
        ),
      ),
    );
  }
}