import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../utility/Colors.dart';
import 'MachineTransferRequest.dart';


class MachineTransferRequestList extends StatefulWidget {
  const MachineTransferRequestList({Key? key}) : super(key: key);

  @override
  _MachineTransferRequestListState createState() => _MachineTransferRequestListState();
}

class _MachineTransferRequestListState extends State<MachineTransferRequestList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(children: <Widget>[
            Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientStart,gradientEnd
                      ],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50))
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Request List',
                        style: TextStyle(fontSize: 30,color: Colors.white),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          elevation: 10,
                          textStyle: TextStyle(color: Colors.white),
                          backgroundColor: orange,
                          padding: EdgeInsets.only(left: 10,right: 15),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MachineTransferRequest()))
                        },
                        icon: Icon(Icons.create_rounded,color: Colors.white,),
                        label: Text('Create new',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                )
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('MODEL')),
                  DataColumn(label: Text('CODE')),
                  DataColumn(label: Text('ASSIGN DATE')),
                  DataColumn(label: Text('FROM')),
                  DataColumn(label: Text('TO'))
                ],
                showCheckboxColumn: false,
                rows: List<DataRow>.generate(requestList.length, (index) => DataRow(
                  cells: [
                    DataCell(
                      Text(requestList[index]['product_details']['product']['product_model'],softWrap: true,overflow: TextOverflow.fade,)
                    ),
                    DataCell(
                      Text(requestList[index]['product_details']['ventura_code'],overflow: TextOverflow.fade,),
                    ),
                    DataCell(
                      Text(requestList[index]['assign_date']),
                    ),
                    DataCell(
                      Text(requestList[index]['from_area_name']?['floor_no'] ??  'N/A',overflow: TextOverflow.fade,),
                    ),
                    DataCell(
                      Text(requestList[index]['to_area_name']['floor_no'],overflow: TextOverflow.fade,),
                    ),
                  ],
                )),
              ),
            ),
          ])
      ),
    );
  }


  List<dynamic> requestList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getRequestList();
  }

  Future<String> getRequestList() async{
    final pref = await SharedPreferences.getInstance();
    int? userId = pref.getInt('user_id');
    var res = await http.get(Uri.parse('https://dm.vlmbd.com/machine_transfer_request_list/'+userId.toString()),headers: {"Accept": "application/json"});
    if(res.body.isNotEmpty){
      setState(() {
        //requestList = json.decode(res.body);
        var jsonDecode = json.decode(res.body);
        requestList = jsonDecode['data'];
      });
    }
    return 'Success';
  }



  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}


