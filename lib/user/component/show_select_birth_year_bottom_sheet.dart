import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

Future<DateTime?> showSelectBirthYearBottomSheet({
  required BuildContext context,
  required DateTime initialDateTime,
}) {
  final DateTime adjustedInitialDateTime =
      initialDateTime.year == Constants.birthYearNotSelected
          ? DateTime(DateTime.now().year)
          : initialDateTime;
  final int currentYear = DateTime.now().year;
  DateTime tempSavedDate = adjustedInitialDateTime;

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
                    child: CupertinoPicker.builder(
                      scrollController: FixedExtentScrollController(
                        initialItem: currentYear - adjustedInitialDateTime.year,
                      ),
                      childCount: currentYear - 1900 + 1,
                      itemBuilder: (context, index) => Center(
                        child: Text(
                          '${currentYear - index}년',
                          style: CustomTextStyle.head4(),
                        ),
                      ),
                      selectionOverlay: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.5),
                        child: CupertinoPickerDefaultSelectionOverlay(),
                      ),
                      itemExtent: 40.0,
                      onSelectedItemChanged: (int index) =>
                          tempSavedDate = DateTime(currentYear - index),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 94,
                      child: CustomSelectButton(
                        isInkWell: true,
                        onTap: () => context.pop(
                          DateTime(Constants.birthYearNotSelected),
                        ),
                        content: '선택안함',
                        backgroundColor: ColorName.white000,
                        textStyle: CustomTextStyle.body1Medi(),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 233,
                      child: CustomSelectButton(
                        content: '선택',
                        onTap: () => context.pop(tempSavedDate),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
