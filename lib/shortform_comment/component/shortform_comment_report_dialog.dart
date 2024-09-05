import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_report_type.provider.dart';

Future<CommentReportType?> showShortFormCommentReportDialog({
  required BuildContext context,
}) {
  return showDialog<CommentReportType?>(
    context: context,
    builder: (context) => Consumer(
      builder: (_, ref, child) {
        final reportType = ref.watch(shortFormCommentReportTypeProvider);

        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Text('댓글 신고 사유 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in CommentReportType.values)
                RadioListTile<CommentReportType>(
                  title: Text(type.message),
                  value: type,
                  groupValue: reportType,
                  onChanged: (value) => ref
                      .read(shortFormCommentReportTypeProvider.notifier)
                      .state = value ?? CommentReportType.spam,
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
