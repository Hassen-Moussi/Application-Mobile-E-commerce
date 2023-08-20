import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';





class QrCode extends StatelessWidget {
  final String value1;
  final String value2;

  const QrCode({required this.value1, required this.value2, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = '$value1 $value2';
    return QrImage(
      data: data,
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}






