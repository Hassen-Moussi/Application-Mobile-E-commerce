import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../routes/routes.dart';

class MyQrValuePage extends StatefulWidget {
  @override
  _MyQrValPageState createState() => _MyQrValPageState();
}

class _MyQrValPageState extends State<MyQrValuePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product info Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter product name...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(
                hintText: 'Enter product price...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () async{
              await storage.write(key: 'productname', value: _nameController.text);
              await storage.write(key: 'productvalue', value: _priceController.text);
             setState(() {
               Get.offAllNamed(Croutes.qrgen);
             }); // Handle submit button pressed

            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}