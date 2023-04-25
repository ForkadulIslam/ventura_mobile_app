import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'Colors.dart';

ElevatedButton buildElevatedButton (buttonText, onPressed){
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40))),
    child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientStart,gradientEnd
            ],
            end: Alignment.topLeft,
            begin: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(40)
      ),
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

ElevatedButton buildServiceElevatedButton(buttonText, icon, onPressed){
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    child: Ink(
      decoration: BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 100,
        height: 90,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(height: 5,),
            AutoSizeText(
              buttonText,
              style: TextStyle(fontWeight: FontWeight.bold),
              minFontSize: 12,
              maxFontSize: 15,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    ),
  );
}

