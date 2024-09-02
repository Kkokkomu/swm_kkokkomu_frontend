import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

class CustomToastMessage {
  // 로그인 에러시 토스트 메시지 띄우기
  static Future<bool?> showLoginError(String errorMessage) =>
      Fluttertoast.showToast(
        msg: '$errorMessage\n다시 로그인 해주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorName.error500,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  // 일반적인 에러 토스트 메시지
  static Future<bool?> showErrorToastMessage(String errorMessage) =>
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorName.error500,
        textColor: Colors.white,
        fontSize: 16.0,
      );

  // 일반적인 완료 토스트 메시지
  static Future<bool?> showSuccessToastMessage(String errorMessage) =>
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorName.success500,
        textColor: Colors.black,
        fontSize: 16.0,
      );
}
