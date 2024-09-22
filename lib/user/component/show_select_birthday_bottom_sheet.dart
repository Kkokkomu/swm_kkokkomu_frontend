import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

Future<DateTime?> showSelectBirthDayBottomSheet({
  required BuildContext context,
  required DateTime initialDateTime,
}) {
  DateTime tempSavedDate = initialDateTime;

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Container(
          color: ColorName.white000,
          height: 320.0 + MediaQuery.of(context).padding.bottom,
          child: Column(
            children: [
              const SizedBox(height: 5.5),
              const CustomGrabber(),
              const SizedBox(height: 36.73),
              ShaderMask(
                shaderCallback: (Rect bounds) => LinearGradient(
                  colors: [
                    ColorName.white000.withOpacity(0.0),
                    ColorName.white000.withOpacity(1.0),
                    ColorName.white000.withOpacity(1.0),
                    ColorName.white000.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.39, 0.61, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: SizedBox(
                  height: 159.0,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: CustomTextStyle.head4(),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      itemExtent: 35.0,
                      initialDateTime: initialDateTime,
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime newDateTime) {
                        tempSavedDate = newDateTime;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomSelectButton(
                  content: '선택',
                  onTap: () => context.pop(tempSavedDate),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
