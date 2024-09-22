import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_radio_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';

Future<GenderType?> showSelectGenderBottomSheet({
  required BuildContext context,
  required GenderType initialGender,
}) {
  GenderType selectedGender = initialGender;

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (_, setState) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: Container(
          color: ColorName.white000,
          height: 252.0 + MediaQuery.of(context).padding.bottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5.5),
              const Center(
                child: CustomGrabber(),
              ),
              const SizedBox(height: 9.73),
              Row(
                children: [
                  const SizedBox(width: 18.0),
                  Text(
                    '성별 선택',
                    style: CustomTextStyle.head3(),
                  ),
                  const Spacer(),
                  const CustomCloseButton(),
                  const SizedBox(width: 4.0),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 14.0, 18.0, 48.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  spacing: 18.0,
                  children: [
                    for (GenderType gender in GenderType.values)
                      CustomRadioButton(
                        onTap: () => setState(() => selectedGender = gender),
                        isEnabled: gender == selectedGender,
                        text: gender.label,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomSelectButton(
                  content: '선택',
                  onTap: () => context.pop(selectedGender),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
