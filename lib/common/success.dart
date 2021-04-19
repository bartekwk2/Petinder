import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSuccess(BuildContext context, String text, String textMain,
    {int duration}) {
  Flushbar flushbar;
  flushbar = Flushbar(
    title: textMain,
    onStatusChanged: (status) {
      print("STATUS $status");
    },
    message: text,
    duration: Duration(seconds: duration ?? 10),
    flushbarPosition: FlushbarPosition.BOTTOM,
    flushbarStyle: FlushbarStyle.GROUNDED,
    reverseAnimationCurve: Curves.decelerate,
    forwardAnimationCurve: Curves.elasticInOut,
    backgroundColor: Colors.green,
    boxShadows: [
      BoxShadow(
        color: Colors.blue[800],
        offset: Offset(0.0, 2.0),
        blurRadius: 3.0,
      ),
    ],
    backgroundGradient: LinearGradient(
      colors: [Color(0xff2CAA5F), Color(0xff43884D)],
    ),
    isDismissible: true,
    icon: Icon(
      Icons.error_outline,
      color: Color(0xffF6F7D7),
    ),
    mainButton: FlatButton(
      onPressed: () {
        flushbar.dismiss();
      },
      child: Text(
        'Ok',
        style: TextStyle(color: Colors.white),
      ),
    ),
  )..show(context);
}
