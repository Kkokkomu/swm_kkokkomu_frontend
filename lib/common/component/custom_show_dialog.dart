import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

Future<dynamic> showAppExitDialog(BuildContext context) {
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
          onPressed: () => SystemNavigator.pop(),
          child: const Text('종료'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
      ],
    ),
  );
}

Future<dynamic> showRegisterCancelDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: const Text(
        '회원 등록을 취소하시겠습니까?',
        style: TextStyle(fontSize: 16.0),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: () => ref.read(userInfoProvider.notifier).cancelRegister(),
          child: const Text('등록 취소'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('계속하기'),
        ),
      ],
    ),
  );
}
