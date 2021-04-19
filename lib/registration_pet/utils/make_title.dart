import 'package:flutter/material.dart';

Widget makeTitle(String text, {double fontSize,double left}) {
  return Padding(
    padding: EdgeInsets.only(left: left??25.0, bottom: 12.0),
    child: Container(
      child: Text(text,
          style: TextStyle(
            fontSize: fontSize??24.0,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}
