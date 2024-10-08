import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String content,
  String? details,
  required String confirmText,
  required String cancelText,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => AlertDialog(
      surfaceTintColor: ColorName.white000,
      backgroundColor: ColorName.white000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.body1Bold(),
                ),
              ),
              const SizedBox(height: 18.0),
              if (details != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    details,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.detail1Reg(color: ColorName.gray300),
                  ),
                ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => context.pop(false),
                      child: Container(
                        height: 52.0,
                        color: ColorName.gray100,
                        child: Center(
                          child: Text(
                            cancelText,
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
                      onTap: () => context.pop(true),
                      child: Container(
                        height: 52.0,
                        color: ColorName.gray600,
                        child: Center(
                          child: Text(
                            confirmText,
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
    ),
  );
}

Future<void> showAppExitDialog(BuildContext context) async {
  final resp = await showConfirmationDialog(
    context: context,
    content: '앱을 종료하시겠어요?',
    confirmText: '종료',
    cancelText: '취소',
  );

  if (resp == true) {
    SystemNavigator.pop();
  }
}

Future<void> showInfoDialog({
  required BuildContext context,
  required String content,
  String? details,
  String? checkMessage,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      surfaceTintColor: ColorName.white000,
      backgroundColor: ColorName.white000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: CustomTextStyle.body1Bold(),
                ),
              ),
              const SizedBox(height: 18.0),
              if (details != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    details,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.detail1Reg(color: ColorName.gray300),
                  ),
                ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  height: 52.0,
                  color: ColorName.gray600,
                  child: Center(
                    child: Text(
                      checkMessage ?? '확인',
                      style: CustomTextStyle.body1Bold(
                        color: ColorName.white000,
                      ),
                    ),
                  ),
                ),
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
    ),
  );
}

Future<void> showForceCheckDialog({
  required BuildContext context,
  required String content,
  required String checkMessage,
  String? details,
  void Function()? onCheck,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        surfaceTintColor: ColorName.white000,
        backgroundColor: ColorName.white000,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.72,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.body1Bold(),
                  ),
                ),
                const SizedBox(height: 18.0),
                if (details != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      details,
                      textAlign: TextAlign.center,
                      style:
                          CustomTextStyle.detail1Reg(color: ColorName.gray300),
                    ),
                  ),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: onCheck,
                  child: Container(
                    height: 52.0,
                    color: ColorName.gray600,
                    child: Center(
                      child: Text(
                        checkMessage,
                        style: CustomTextStyle.body1Bold(
                          color: ColorName.white000,
                        ),
                      ),
                    ),
                  ),
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
      ),
    ),
  );
}
