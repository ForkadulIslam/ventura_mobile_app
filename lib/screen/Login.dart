import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/Colors.dart';
import '../utility/ElevatedButtonStyle.dart';
import '../utility/InputDecoration.dart';
import 'Dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _loginForm = new GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  bool progressVisibility = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //padding: EdgeInsets.all(10),
          child: Form(
            key: _loginForm,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientStart,gradientEnd
                      ],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))
                  ),
                  child: Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  //height: double.infinity,
                  padding: EdgeInsets.all(20),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration:BoxDecoration(
                            color: Color(0xffffffff)
                        ),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Phone number is must';
                            }else{
                              return null;
                            }
                          },
                          decoration: buildInputDecoration('VENTURA PHONE NUMBER', Icons.phone),
                          maxLength: 11,
                          keyboardType: TextInputType.text,
                          controller: phoneNumberController,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          visible: progressVisibility,
                          child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: CircularProgressIndicator()
                          )
                      ),
                      buildElevatedButton('LOGIN', () async {
                        if(_loginForm.currentState!.validate()){
                          setState(() {
                            progressVisibility = true;
                          });
                          try {
                            var res = await http.get(Uri.parse('https://api.vlmbd.com/api/send_sms?mobile_no='+phoneNumberController.text),headers: {"Accept": "application/json"});
                            if(res.body.isNotEmpty){
                              setState(() {
                                progressVisibility = false;
                              });
                              String resString = res.body.toString();
                              Map<String, dynamic> map = jsonDecode(resString);
                              if(map['status'] == 3){
                                _showToast(context,'Phone number could not found in database');
                              }else if(map['status'] == 2) {
                                _showToast(context,'API internal error');
                              }else{
                                showDialog(
                                    barrierDismissible:false,
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text('Enter OTP code',style: TextStyle(color: primaryBlue,fontSize: 20),),
                                        content: Container(
                                          height: MediaQuery.of(context).size.height*.3,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextField(
                                                decoration: buildInputDecoration('Phone code', Icons.sms_rounded),
                                                controller: pinController,
                                              ),
                                              buildElevatedButton('Validate', () async{
                                                var smsCode = pinController.text;
                                                setState(() {
                                                  progressVisibility = true;
                                                });
                                                var checkOpt = await http.get(Uri.parse('https://api.vlmbd.com/api/check_otp/$smsCode/'+phoneNumberController.text),headers: {"Accept": "application/json"});
                                                Map<String,dynamic> checkOptRes = jsonDecode(checkOpt.body.toString());
                                                if(checkOptRes['status'] == 1){
                                                  var res = await http.get(Uri.parse('https://api.vlmbd.com/api/get_employee_by_phone_no?mobile_no='+phoneNumberController.text),headers: {"Accept": "application/json"});
                                                  if(res.body.isNotEmpty){
                                                    //phoneAuth(resString);
                                                    String resString = res.body.toString();
                                                    Map<String, dynamic> map = jsonDecode(resString);
                                                    final sharedPreference = await SharedPreferences.getInstance();
                                                    sharedPreference.setBool('isLoggedIn', true);
                                                    sharedPreference.setString('phone', phoneNumberController.text);
                                                    sharedPreference.setString('employee_id', map['employee_id']!.toString());
                                                    sharedPreference.setString('name', map['employee_name']!.toString());
                                                    sharedPreference.setString('designation', map['designation']!.toString());
                                                    sharedPreference.setString('division', map['division']!.toString());
                                                    sharedPreference.setString('department_name', map['department_name']!.toString());
                                                    sharedPreference.setInt('user_id',map['user_id']!);
                                                    sharedPreference.setString('login_token',map['login_token']!);
                                                    sharedPreference.setString('firebase_token',map['firebase_token'].toString());
                                                    setState(() {
                                                      progressVisibility = false;
                                                    });
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(builder: (context) => Dashboard())
                                                    );
                                                  }else{
                                                    _showToast(context,'Phone number could not found in database');
                                                    setState(() {
                                                      progressVisibility = false;
                                                    });
                                                  }
                                                }else{
                                                  setState(() {
                                                    progressVisibility = false;
                                                  });
                                                }
                                              })
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }
                            }

                          } catch (err) {
                            print(err);
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
