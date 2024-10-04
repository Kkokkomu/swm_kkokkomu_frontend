import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_report_type_provider.dart';

Future<CommentReportType?> showShortFormCommentReportDialog({
  required BuildContext context,
}) {
  return showDialog<CommentReportType?>(
    context: context,
    builder: (context) => Consumer(
      builder: (_, ref, __) {
        final reportType = ref.watch(shortFormCommentReportTypeProvider);

        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 28.0),
                  Text(
                    '신고 사유가 무엇인가요?',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.body1Bold(),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '가장 근접한 사유를 선택해주세요',
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.detail2Reg(color: ColorName.gray300),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final type in CommentReportType.values)
                          GestureDetector(
                            onTap: () => ref
                                .read(
                                    shortFormCommentReportTypeProvider.notifier)
                                .state = type,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 18.0,
                                right: 12.0,
                              ),
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: double.infinity,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: reportType == type
                                    ? ColorName.blue100
                                    : ColorName.gray50,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      type.message,
                                      style: CustomTextStyle.body3Medi(
                                        color: reportType == type
                                            ? ColorName.gray700
                                            : ColorName.gray200,
                                      ),
                                    ),
                                    reportType == type
                                        ? Assets.icons.svg.icCheckEnabled.svg()
                                        : Assets.icons.svg.icCheckDisabled
                                            .svg(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            height: 52.0,
                            color: ColorName.gray100,
                            child: Center(
                              child: Text(
                                '취소',
                                style: CustomTextStyle.body1Bold(
                                  color: ColorName.gray300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () => context.pop(reportType),
                          child: Container(
                            height: 52.0,
                            color: ColorName.gray600,
                            child: Center(
                              child: Text(
                                '신고하기',
                                style: CustomTextStyle.body1Bold(
                                  color: ColorName.white000,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          insetPadding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
        );
      },
    ),
  );
}
