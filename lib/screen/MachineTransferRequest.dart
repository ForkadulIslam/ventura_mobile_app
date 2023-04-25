import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'MachineTransferRequestForm.dart';

class MachineTransferRequest extends StatefulWidget {
  const MachineTransferRequest({Key? key}) : super(key: key);

  @override
  _MachineTransferRequestState createState() => _MachineTransferRequestState();
}

class _MachineTransferRequestState extends State<MachineTransferRequest> {

  String _scanBarcode = 'Unknown';
  bool progressVisibility = false;
  Future getMachineDetails(machineCode) async{
    setState(() {
      progressVisibility = true;
    });
    print(machineCode);
    var result = await http.get(Uri.parse('https://api.vlmbd.com/api/get_machine_by_code/'+machineCode));
    //print('----------${result.body.toString()}');
    String jsonStr = result.body.toString();
    //print(jsonStr);
    Map<String, dynamic> jsonData = jsonDecode(jsonStr);
    if(result.statusCode != 200){
      _showToast(context, "${jsonData['qr_code']}, not found in database. Try with another one");
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MachineTransferRequestForm(jsonStr)));
    }
    setState(() {
      progressVisibility = false;
    });
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print(PlatformException);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    if(barcodeScanRes.toString() != '-1'){
      getMachineDetails(barcodeScanRes);
    }
    //print('--------$barcodeScanRes');
  }
  void _showToast(BuildContext context,String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'CLEAR', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Machine Transfer Request')),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
                maintainAnimation: true,
                maintainState: true,
                visible: progressVisibility,
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: CircularProgressIndicator()
                )
            ),
            progressVisibility ? Text('Please Wait...',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),) : ElevatedButton(
              onPressed: () => scanBarcodeNormal(),
              child: Text('SCAN CODE')
            ),
          ],
        )
      ),
    );
  }



}
