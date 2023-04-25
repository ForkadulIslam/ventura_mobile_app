import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


import '../utility/Colors.dart';
import '../utility/ElevatedButtonStyle.dart';
import 'MachineTransferRequest.dart';



class MachineTransferRequestForm extends StatefulWidget {
 // MachineTransferRequestForm({Key? key}) : super(key: key);

  var machineObj;
  MachineTransferRequestForm(this.machineObj);

  @override
  _MachineTransferRequestFormState createState() => _MachineTransferRequestFormState();
}

class _MachineTransferRequestFormState extends State<MachineTransferRequestForm> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> MachineTransferRequestFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gradientStart,gradientEnd
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QR CODE:'+ jsonDecode(widget.machineObj)['ventura_code']! +' - ${jsonDecode(widget.machineObj)['asset_issue']?['department']['department_name'].toString()}',
                          style: TextStyle(fontSize: 26,color: orange,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'TPM CODE: '+ jsonDecode(widget.machineObj)['tpm_serial_code'].toString(),
                          style: TextStyle(fontSize: 16,color: orange,fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Description: ',
                              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                jsonDecode(widget.machineObj)['product']['product_name'],
                                style: TextStyle(fontSize: 15,color: Colors.white),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Description CN: ',
                              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                jsonDecode(widget.machineObj)['product']['china_name'],
                                style: TextStyle(fontSize: 15,color: Colors.white),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Category: ',
                              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              jsonDecode(widget.machineObj)['product']['category']['category_name'],
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Type: ',
                              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              jsonDecode(widget.machineObj)['product']['machine_type'].toString(),
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Current Location : ',
                              style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold,),
                            ),
                            jsonDecode(widget.machineObj)['product_status'] != null ? Text(
                              jsonDecode(widget.machineObj)['product_status']['to_area_name']['floor_no'].toString() + '-' + jsonDecode(widget.machineObj)['product_status']['to_location']['line_no'].toString(),
                              style: TextStyle(fontSize: 15,color: Colors.white),
                            ) : Text('N/A',style: TextStyle(fontSize: 15,color: orange,fontWeight: FontWeight.bold),)
                          ],
                        )
                      ],
                    ),
                  )
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height*0.7,
                width: double.infinity,
                child: Form(
                  key:MachineTransferRequestFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text('TO AREA',style: TextStyle(fontSize: 20,color: primaryBlue,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Floor',
                            ),
                            isExpanded: true,
                            iconEnabledColor: orange,
                            style: TextStyle(color: orange, fontSize: 16),
                            focusColor: Colors.black,
                            items: floorData.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item['floor_no']),
                                value: item['floor_id'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal){
                              setState((){
                                selectedFloor = newVal.toString();
                                lineInfo = [];
                                selectedLine = null;
                                isLoading = true;
                                getLineInfo(selectedFloor);
                              });
                            },
                            value: selectedFloor,
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text('TO LOCATION',style: TextStyle(fontSize: 20,color: primaryBlue,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: DropdownButtonFormField(
                            //controller:MachineTransferRequestFormKey,
                            validator: (value) => value == null ? 'To location area is required' : null,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: isLoading ? 'Loading...' : 'Line',
                            ),
                            isExpanded: true,
                            iconEnabledColor: orange,
                            style: TextStyle(color: orange, fontSize: 16),
                            focusColor: Colors.black,
                            items: lineInfo.map((item2) {
                              return new DropdownMenuItem(
                                child: new Text(item2['line_no']),
                                value: item2['line_id'].toString(),
                              );
                            }).toList(),
                            onChanged: (newVal2) {
                              setState(() {
                                selectedLine = newVal2.toString();
                              });
                            },
                            value: selectedLine,
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text('STATUS',style: TextStyle(fontSize: 20,color: primaryBlue,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? 'Status is required' : null,
                            decoration: InputDecoration(
                              filled: true,
                              labelText: 'Status',
                            ),
                            isExpanded: true,
                            iconEnabledColor: orange,
                            style: TextStyle(color: orange, fontSize: 16),
                            focusColor: Colors.black,
                            value: selectedStatus,
                            onChanged: (value){
                              setState(() {
                                selectedStatus = value.toString();
                              });
                            },
                            items: statusItem.map((Status item) {
                              return  DropdownMenuItem<String>(
                                  value: item.st_id.toString(),
                                  child: Text(item.title.toString())
                              );
                            },).toList(),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            visible: progressVisibility,
                            child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()
                            )
                        ),
                        buildElevatedButton(progressVisibility ? 'Please wait...' : 'TRANSFER', () async{
                          if(MachineTransferRequestFormKey.currentState!.validate()){
                            setState(() {
                              progressVisibility = true;
                            });
                            final sharedPreference = await SharedPreferences.getInstance();
                            //print("Floor:{$selectedFloor}, Line: {$selectedLine}, Status:{$selectedStatus}");
                            Map<String, String> formData = {
                              'product_status_id' : jsonDecode(widget.machineObj)['product_status']??['product_status_id'].toString(),
                              'floor_id': selectedFloor.toString(),
                              'line_id':selectedLine.toString(),
                              'status': selectedStatus.toString(),
                              'user_id': sharedPreference.getInt('userId').toString(),
                            };
                            //print('---------${formData}');
                            var res = await http.post(
                              Uri.parse('https://api.vlmbd.com/api/save_machine_transfer_request'),
                              body: formData,
                            );
                            //print(res.statusCode);
                            if(res.statusCode == 200){
                              if(res.body.isNotEmpty){
                                setState(() {
                                  progressVisibility = false;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MachineTransferRequest()));
                              }
                            }else{
                              print(res.body);
                            }
                          }
                        })
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getFloor();
    this.getLineInfo(1);
  }

  String? selectedFloor;
  String? selectedLine;
  String? selectedStatus;
  List floorData = [];
  List lineInfo = [];
  bool isLoading = false;
  bool progressVisibility = false;
  static const List<Status> statusItem = <Status>[
    const Status(1,'USED 使用中'),
    const Status(2,'IDLE 閑置中'),
    const Status(3,'UNDER SERVICE 维修中'),
    const Status(4,'DEACTIVE 停用'),
    const Status(5,'DISPOSE'),
    const Status(6,'NOT FOUND'),
    const Status(7,'NOT ASSIGN'),
  ];
  Future<String> getFloor() async {
    final String url = "https://dm.vlmbd.com/get_floor";
    var res = await http
        .get(Uri.parse(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      floorData = resBody;
    });
    return "Success";
  }

  Future<String> getLineInfo(floorId) async{
    var res = await http.get(Uri.parse('https://dm.vlmbd.com/get_floor_line/'+floorId.toString()),headers: {"Accept": "application/json"});
    var respBody = json.decode(res.body);
    setState(() {
      lineInfo = respBody;
      isLoading = false;
    });
    //print(lineInfo);
    return "Success";
  }



  @override
  void dispose() {
    super.dispose();
  }

}

class Status {
  const Status(this.st_id, this.title);
  final int? st_id; final String? title;
}
