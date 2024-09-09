import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/shortform_report_type_provider.dart';

Future<ShortFormReportType?> showShortFormReportDialog({
  required BuildContext context,
}) {
  return showDialog<ShortFormReportType?>(
    context: context,
    builder: (context) => Consumer(
      builder: (_, ref, child) {
        final reportType = ref.watch(shortFormReportTypeProvider);

        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Text('신고 사유 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in ShortFormReportType.values)
                RadioListTile<ShortFormReportType>(
                  title: Text(type.message),
                  value: type,
                  groupValue: reportType,
                  onChanged: (value) => ref
                      .read(shortFormReportTypeProvider.notifier)
                      .state = value ?? ShortFormReportType.spam,
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: ColorName.error500,
              ),
              onPressed: () => context.pop(reportType),
              child: const Text('신고'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
              onPressed: () => context.pop(),
              child: const Text('취소'),
            ),
          ],
        );
      },
    ),
  );
}
