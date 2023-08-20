import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../routes/routes.dart';
import '../services/services.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final storage = new FlutterSecureStorage();
  userformservice service = userformservice();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  if (result != null)
                    Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Text('Flash: ${snapshot.data}');
                          },
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Text(
                                  'Camera facing ${describeEnum(snapshot.data!)}');
                            } else {
                              return const Text('loading');
                            }
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller?.pauseCamera();
                  },
                  child: const Text('pause', style: TextStyle(fontSize: 20)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () async {
                    await controller?.resumeCamera();
                  },
                  child: const Text('resume', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildQrView(BuildContext context) {
    return QRView(
      onQRViewCreated: _onQRViewCreated,
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).accentColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  bool isScanning = true;
  bool isTransactionProcessed = false;
  int  notify = 0;
  bool isSnackbarDisplayed = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanning || isTransactionProcessed) return;

      final code = scanData.code;
      String value1string = '';
      String value2string = '';
      if (code != null) {
        final values = code.split(' ');
        if (values.length >= 2) {
          final value1 = values[0];
          final value2 = values[1];
          value1string = value1.toString();
          value2string = value2.toString();
        }
      }

      dynamic EmployeeId = await storage.read(key: 'idvalue');
      String value = scanData.code.toString();

      try {
        dynamic savetransaction =
        await service.AcceptTransaction(value1string, EmployeeId);
        final Map<String, dynamic> savetransactionMap =
        jsonDecode(savetransaction.toString());
        if (savetransactionMap["statusCode"] == 200) {
          isTransactionProcessed = true;
          isScanning = false;
          notify = 1;
          Get.until((route) => Get.currentRoute == Croutes.home);
        }
      } catch (e) {
        isTransactionProcessed = true;
        print('Exception caught: $e');
        isScanning = false;
        notify = 2;
        Get.until((route) => Get.currentRoute == Croutes.home);

      }
      setState(() {
        if (notify == 1 && !isSnackbarDisplayed) {
          isSnackbarDisplayed = true;
          Get.snackbar("Notification", 'Transaction Successful' ,colorText: Colors.green);
          Future.delayed(Duration(seconds: 2), () {
            isSnackbarDisplayed = false;
          });
        } else if (notify == 2 && !isSnackbarDisplayed) {
          isSnackbarDisplayed = true;
          Get.snackbar("Error", 'Transaction Failed' ,colorText: Colors.red);
          Future.delayed(Duration(seconds: 2), () {
            isSnackbarDisplayed = false;
          });
        }
      });
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }





}
