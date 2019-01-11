import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as T;

class Toast {
  static show(String msg) {
    if (Platform.isIOS) {
      T.Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: T.Toast.LENGTH_SHORT,
          gravity: T.ToastGravity.BOTTOM,
          timeInSecForIos: 2);
    } else {
      T.Fluttertoast.showToast(
        msg: msg,
        toastLength: T.Toast.LENGTH_SHORT,
      );
    }
  }
}
