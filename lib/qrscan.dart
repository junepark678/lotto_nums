import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'utilfuncs.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QRViewExampleState();
  }
}

class _QRViewExampleState extends State<QRViewExample> {
  String result = 'Unknown';
  String toset = "Not scanned yet";
  @override
  Widget build(BuildContext context){
    return Center(
      child: Stack(
        children:[
          Text(toset),
          TextButton(
            child: Text('QR코드 스캔'),
            onPressed: () {

              scanQR();
              setState(() {
                if(result.startsWith("https://m.dhlottery.co.kr/qr.do?")){
                  toset = "invalid QR code";
                }
                else
                  toset = result;
              });

            }
          )
        ],
      ),
    );
  }
  Future<void> scanQR() async{
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Back";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }
  Future<void> getElements() async
  {
    String qr = await fetchfromqr(toset);
    await addToWallet(qr);
  }
}