import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToastMessage {
  // 로그인 에러시 토스트 메시지 띄우기
  static Future<bool?> showLoginError(String errorMessage) =>
      Fluttertoast.showToast(
        msg: '$errorMessage\n다시 로그인 해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
}
