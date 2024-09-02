import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String content,
  required String confirmText,
  required String cancelText,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (context) => AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: const TextStyle(fontSize: 16.0),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorName.error500,
          ),
          onPressed: () => context.pop(true),
          child: Text(confirmText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
          ),
          onPressed: () => context.pop(false),
          child: Text(cancelText),
        ),
      ],
    ),
  );
}
