// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../utility/Colors.dart';
import '../utility/ElevatedButtonStyle.dart';
import 'GatepassPage.dart';
import 'Login.dart';
import 'MachineTransferRequestList.dart';

class Dashboard extends StatefulWidget {


  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  String? name= '';
  String? phone = '';
  String? designation = '';
  String? department = '';
  int? userId = 0;
  String? employeeId = '';
  String? fcmToken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('From Dashboard: ${message.notification!.title.toString()}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // final snackBar = SnackBar(
        //   content: Text(message.notification?.title ?? '', maxLines: 2),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message Opened: $message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      final snackBar = SnackBar(
        content: Text(message.notification?.title ?? '', maxLines: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Send request to update Firebase token");
      updateFcmToken();
    });
  }

  updateFcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final sharedPreference = await SharedPreferences.getInstance();
    var apiReq = await http.post(Uri.parse('https://api.vlmbd.com/api/update_firebase_token?user_id=${sharedPreference.getInt('user_id').toString()}&firebase_token=${fcmToken!}'),headers: {"Accept": "application/json"});
    print(apiReq.body);
    if(apiReq.body.isNotEmpty){
      sharedPreference.setString('firebase_token',fcmToken);
    }else{
      print('New token is not updated in DB...');
    }
  }

  void showNotification(String title, String body) {
    flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high, color: Colors.blue, playSound: true, icon: '@mipmap/ic_launcher')));
  }

  Future getUserData() async {
    //print('Get user data fired...');
    final sharedPreference = await SharedPreferences.getInstance();
    setState((){
      employeeId = sharedPreference.getString('employee_id');
      designation = sharedPreference.getString('designation');
      name = sharedPreference.getString('name');
      phone = sharedPreference.getString('phone');
      department = sharedPreference.getString('department_name');
      userId = sharedPreference.getInt('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 300,
                //height: MediaQuery.of(context).size.height*0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradientStart, gradientEnd],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        name!,
                        style: TextStyle(color: Colors.white),
                        maxFontSize: 30,
                        minFontSize: 25,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AutoSizeText(
                        department!,
                        style: TextStyle(color: Colors.white),
                        maxFontSize: 18,
                        minFontSize: 15,
                      ),
                    ],
                  ),
                )),
            Container(
              //height: MediaQuery.of(context).size.height*0.6,
              //height: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildServiceElevatedButton('TPM', Icons.contact_phone, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MachineTransferRequestList()));
                  }),
                  buildServiceElevatedButton('Dispose M.', Icons.alarm, () async {
                    final sharedPreference = await SharedPreferences.getInstance();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GatepassPage(
                              url: 'https://dm.vlmbd.com/?login_token=${sharedPreference.getString('login_token')}',
                            )
                        )
                    );
                  }),
                   
                   buildServiceElevatedButton('GATE PASS', Icons.phone, () async {
                     final sharedPreference = await SharedPreferences.getInstance();
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => GatepassPage(
                               url: 'https://vos.vlmbd.com/logincontroller/login_by_token/${sharedPreference.getString('login_token').toString()}',
                             )
                         )
                     );
                  }),
                ],
              ),
            ),
            Container(
              //height: MediaQuery.of(context).size.height*0.6,
              //height: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildServiceElevatedButton('Payment App', Icons.notification_add, () async {
                    //showNotification();
                    final sharedPreference = await SharedPreferences.getInstance();
                    //print(sharedPreference.getString('login_token').toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GatepassPage(
                                  url: 'https://vos.vlmbd.com/logincontroller/login_by_token/${sharedPreference.getString('login_token').toString()}',
                                )
                        )
                    );
                  }),
                  buildServiceElevatedButton('LAB Automation', Icons.h_plus_mobiledata, () async {
                    final sharedPreference = await SharedPreferences.getInstance();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GatepassPage(
                              url: 'https://lab.vlmbd.com/public?request_from=App&phone_no=${sharedPreference.getString('phone')}',
                            )
                        )
                    );
                  }),
                  buildServiceElevatedButton('HELP DESK', Icons.logout, () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.clear();
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx) => Login()));
                  }),
                ],
              ),
            ),
            Container(
              //height: MediaQuery.of(context).size.height*0.6,
              //height: double.infinity,
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildServiceElevatedButton('Logout', Icons.logout, () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx) => Login()));
                  }),
                ],
              ),
            ),
          ],
        )),
      )),
    );
  }
}
