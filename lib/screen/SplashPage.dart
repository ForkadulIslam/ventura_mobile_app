import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utility/Colors.dart';
import 'Dashboard.dart';
import 'Login.dart';

String? finalPhoneNumber;
bool? isLoggedIn = false;
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin().whenComplete(() async {
      Timer(Duration(microseconds: 4000),(){
        Navigator.pushReplacement(
            // ignore: unnecessary_null_comparison
            context,MaterialPageRoute(builder: (context) => isLoggedIn == false || isLoggedIn == null ? Login() : Dashboard())
        );
      });
    });
  }
  Future checkLogin() async{
    final sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = sharedPreference.getBool('isLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientStart,gradientEnd
            ],
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
          )
        ),
        child: Center(
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
