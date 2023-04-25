import 'package:flutter/material.dart';
import './phone_textfield.dart';
import 'package:call_log/call_log.dart';
import './callLogs.dart';

class PhonelogsScreen extends StatefulWidget {
  @override
  _PhonelogsScreenState createState() => _PhonelogsScreenState();
}

class _PhonelogsScreenState extends State<PhonelogsScreen> with  WidgetsBindingObserver {
  //Iterable<CallLogEntry> entries;
  PhoneTextField pt = new PhoneTextField();
  CallLogs cl = new CallLogs();

  late AppLifecycleState _notification;
  late Future<Iterable<CallLogEntry>> logs;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    logs = cl.getCallLogs();
    _callLogs();
  }

  
  void _callLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    for (var item in entries) {
      print(item.name);
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (AppLifecycleState.resumed == state){
      setState(() {
        logs = cl.getCallLogs();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone"),),
      body: Column(
        children: [
          pt,
          //TextField(controller: t1, decoration: InputDecoration(labelText: "Phone number", contentPadding: EdgeInsets.all(10), suffixIcon: IconButton(icon: Icon(Icons.phone), onPressed: (){print("pressed");})),keyboardType: TextInputType.phone, textInputAction: TextInputAction.done, onSubmitted: (value) => call(value),),


        ],
      ),
    );
  }
}