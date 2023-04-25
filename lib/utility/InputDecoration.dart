import 'package:flutter/material.dart';


import 'Colors.dart';

InputDecoration buildInputDecoration(String hintText, IconData icon){
  return InputDecoration(
    //hintText: hintText,
    hintStyle: TextStyle(
      color: orange
    ),
    prefixIcon: Icon(icon, color: orange,),
    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
    labelText: hintText,
    labelStyle: TextStyle(
        color: orange
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        borderSide: BorderSide(color: orange)
    ),

  );
}