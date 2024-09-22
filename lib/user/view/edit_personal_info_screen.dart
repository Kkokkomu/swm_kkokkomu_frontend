import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/user/provider/nick_name_validation_provider.dart';
import 'package:swm_kkokkomu_frontend/user/component/show_select_birthday_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/user/component/show_select_gender_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/detail_user_info_provider.dart';

class EditPersonalInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'edit-personal-info';

  const EditPersonalInfoScreen({super.key});

  @override
  ConsumerState<EditPersonalInfoScreen> createState() =>
      _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState
    extends ConsumerState<EditPersonalInfoScreen> {
  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final detailUserInfo = ref.watch(detailUserInfoProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultLayout(
        resizeToAvoidBottomInset: true,
        statusBarBrightness: Brightness.dark,
        appBarHeight: 48.0,
        titleWidget: Text(
          '내 정보 수정',
          style: CustomTextStyle.head4(),
        ),
        centerTitle: true,
        titleLeading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.pop(),
            child: Assets.icons.svg.btnBack.svg(),
          ),
        ),
        titleLeadingWidth: 48.0,
        appBarBottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: ColorName.gray100,
            height: 0.5,
          ),
        ),
        child: switch (detailUserInfo) {
          DetailUserModelLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          DetailUserModelError() => Center(
              child: Text(
                '유저 정보를 불러오는데 실패했습니다.',
                style: CustomTextStyle.body2Reg(),
              ),
            ),
          DetailUserModel() => Consumer(
              builder: (_, ref, __) {
                final nickNameValidation = ref.watch(
                    nickNameValidationProvider(formKey)
                        .select((value) => value));

                if (!isInitialized) {
                  isInitialized = true;
                  nicknameController.text = detailUserInfo.nickname;
                  birthdayController.text = detailUserInfo.birthday;
                  genderController.text = detailUserInfo.sex.label;
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24.0),
                              CustomTextFormField(
                                controller: nicknameController,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (value) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    ref
                                        .read(
                                            nickNameValidationProvider(formKey)
                                                .notifier)
                                        .setValidation(value);
                                  });

                                  if (ref
                                      .read(nickNameValidationProvider(formKey)
                                          .notifier)
                                      .validateNickName(value)) {
                                    return null;
                                  } else {
                                    return '';
                                  }
                                },
                                labelText: '닉네임',
                                hintText: '닉네임을 입력해주세요',
                                maxLength: 10,
                                suffixIcon: GestureDetector(
                                  onTap: () => nicknameController.clear(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Assets.icons.svg.btnDelete.svg(),
                                  ),
                                ),
                                helper: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: nickNameValidation
                                                .isMoreOrEqualThanTwoCharacters
                                            ? Assets.icons.svg.icCheckEnabled
                                                .svg()
                                            : Assets.icons.svg.icCheckDisabled
                                                .svg(),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                      TextSpan(
                                        text: '2자 이상\n',
                                        style: CustomTextStyle.detail3Reg(
                                          color: nickNameValidation
                                                  .isMoreOrEqualThanTwoCharacters
                                              ? ColorName.blue500
                                              : ColorName.gray300,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: nickNameValidation
                                                .isAlphaOrNumericOrKorean
                                            ? Assets.icons.svg.icCheckEnabled
                                                .svg()
                                            : Assets.icons.svg.icCheckDisabled
                                                .svg(),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                      TextSpan(
                                        text: '영어, 완성형 한글, 숫자만',
                                        style: CustomTextStyle.detail3Reg(
                                          color: nickNameValidation
                                                  .isAlphaOrNumericOrKorean
                                              ? ColorName.blue500
                                              : ColorName.gray300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                errorMessage: nickNameValidation.errorMessage ==
                                        null
                                    ? null
                                    : Text.rich(
                                        textAlign: TextAlign.end,
                                        TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: SizedBox(height: 24.0),
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                            ),
                                            TextSpan(
                                              text: nickNameValidation
                                                  .errorMessage,
                                              style: CustomTextStyle.detail3Reg(
                                                color: ColorName.error500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 32.0),
                              CustomTextFormField(
                                onTap: () async {
                                  final selectedDate =
                                      await showSelectBirthDayBottomSheet(
                                    context: context,
                                    initialDateTime: DateFormat('yyyy-MM-dd')
                                            .tryParse(
                                                birthdayController.text) ??
                                        DateTime.now(),
                                  );

                                  if (selectedDate != null) {
                                    birthdayController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(selectedDate);
                                  }
                                },
                                controller: birthdayController,
                                readOnly: true,
                                labelText: '생년월일',
                                hintText: '생년월일을 선택해주세요',
                              ),
                              const SizedBox(height: 32.0),
                              CustomTextFormField(
                                onTap: () async {
                                  final selectedGender =
                                      await showSelectGenderBottomSheet(
                                    context: context,
                                    initialGender: GenderType.fromLabel(
                                            genderController.text) ??
                                        GenderType.none,
                                  );

                                  if (selectedGender != null) {
                                    genderController.text =
                                        selectedGender.label;
                                  }
                                },
                                controller: genderController,
                                readOnly: true,
                                labelText: '성별',
                                hintText: '성별을 선택해주세요',
                              ),
                              const SizedBox(height: 24.0),
                              Container(
                                width: double.infinity,
                                height: 0.5,
                                color: ColorName.gray200,
                              ),
                              const SizedBox(height: 18.0),
                              Text(
                                '생일과 성별은 맞춤 추천 알고리즘에만 사용되고\n다른 사용자에게 노출되지 않아요',
                                style: CustomTextStyle.detail1Reg(
                                  color: ColorName.gray300,
                                ),
                              ),
                              const SizedBox(height: 35.0),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GestureDetector(
                          onTap: nickNameValidation.isValid
                              ? () async {
                                  // 내 정보 수정 요청
                                  final resp = await ref
                                      .read(detailUserInfoProvider.notifier)
                                      .updateUserPersonalInfo(
                                        nickname: nicknameController.text,
                                        birthday: birthdayController.text,
                                        sex: GenderType.fromLabel(
                                          genderController.text,
                                        ),
                                      );

                                  // 내 정보 수정 실패
                                  if (!resp) {
                                    CustomToastMessage.showErrorToastMessage(
                                      '내 정보 수정에 실패했습니다',
                                    );
                                    return;
                                  }

                                  // 내 정보 수정 성공
                                  CustomToastMessage.showSuccessToastMessage(
                                    '내 정보가 수정되었습니다',
                                  );
                                  if (context.mounted) context.pop();
                                }
                              : null,
                          child: CustomSelectButton(
                            content: '저장',
                            backgroundColor: nickNameValidation.isValid
                                ? ColorName.gray600
                                : ColorName.gray100,
                            textColor: nickNameValidation.isValid
                                ? ColorName.white000
                                : ColorName.gray200,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        },
      ),
    );
  }
}
