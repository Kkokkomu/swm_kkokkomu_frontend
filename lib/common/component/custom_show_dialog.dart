import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> appExitShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: const Text(
        '앱을 종료하시겠습니까?',
        style: TextStyle(fontSize: 16.0),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text('종료'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
      ],
    ),
  );
}
