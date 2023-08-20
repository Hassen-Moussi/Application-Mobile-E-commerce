import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../routes/routes.dart';
import '../services/services.dart';

class MyPaymentPage extends StatefulWidget {
  @override
  _MyPaymentPageState createState() => _MyPaymentPageState();
}

class _MyPaymentPageState extends State<MyPaymentPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final storage = new FlutterSecureStorage();
  userformservice service = userformservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Get.offAllNamed(Croutes.home),
                child: Icon(
                  Icons.arrow_back,
                  size: 32,
                  color: Colors.black54,
                ),
              ),
            ),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () async{
                dynamic idcashier = await storage.read(key: 'idcashier');
                dynamic EmployeeId = await storage.read(key: 'idvalue');
                dynamic prix = await storage.read(key: 'prixvalue');
                double price = double.parse(prix);
                final updatebalance = await service.UpdateBalance(EmployeeId,idcashier, price);
                setState(() {
                  _textEditingController.text=updatebalance.toString();
                  updatebalance;
                });
              },
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}