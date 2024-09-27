import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_text_form_field.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/user/component/show_select_birth_year_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/user/component/show_select_gender_bottom_sheet.dart';
import 'package:swm_kkokkomu_frontend/user/provider/nick_name_validation_provider.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static String get routeName => 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();
  DateTime? birthday;
  GenderType? gender;
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    final nickNameValidation =
        ref.watch(nickNameValidationProvider(formKey).select((value) => value));

    isValid = nickNameValidation.isValid && birthday != null && gender != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        final resp = await showConfirmationDialog(
          context: context,
          content: '회원 등록을 취소하시겠어요?',
          details: '입력한 정보는 저장되지 않아요',
          confirmText: '등록 취소',
          cancelText: '계속하기',
        );

        if (resp == true) {
          ref.read(userInfoProvider.notifier).cancelRegister();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: DefaultLayoutWithDefaultAppBar(
          resizeToAvoidBottomInset: true,
          statusBarBrightness: Brightness.dark,
          title: '프로필 설정',
          onBackButtonPressed: () async {
            final resp = await showConfirmationDialog(
              context: context,
              content: '회원 등록을 취소하시겠어요?',
              details: '입력한 정보는 저장되지 않아요',
              confirmText: '등록 취소',
              cancelText: '계속하기',
            );

            if (resp == true) {
              ref.read(userInfoProvider.notifier).cancelRegister();
            }
          },
          child: Padding(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref
                                  .read(nickNameValidationProvider(formKey)
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
                                      ? Assets.icons.svg.icCheckEnabled.svg()
                                      : Assets.icons.svg.icCheckDisabled.svg(),
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
                                      ? Assets.icons.svg.icCheckEnabled.svg()
                                      : Assets.icons.svg.icCheckDisabled.svg(),
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
                          errorMessage: nickNameValidation.errorMessage == null
                              ? null
                              : Text.rich(
                                  textAlign: TextAlign.end,
                                  TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: SizedBox(height: 24.0),
                                        alignment: PlaceholderAlignment.middle,
                                      ),
                                      TextSpan(
                                        text: nickNameValidation.errorMessage,
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
                                await showSelectBirthYearBottomSheet(
                              context: context,
                              initialDateTime: birthday ?? DateTime.now(),
                            );

                            if (selectedDate != null) {
                              birthdayController.text = '${selectedDate.year}년';
                              setState(() {
                                birthday = selectedDate;
                              });
                            }
                          },
                          controller: birthdayController,
                          readOnly: true,
                          labelText: '출생연도',
                          hintText: '출생연도를 선택해주세요',
                        ),
                        const SizedBox(height: 32.0),
                        CustomTextFormField(
                          onTap: () async {
                            final selectedGender =
                                await showSelectGenderBottomSheet(
                              context: context,
                              initialGender:
                                  GenderType.fromLabel(genderController.text) ??
                                      GenderType.none,
                            );

                            if (selectedGender != null) {
                              genderController.text = selectedGender.label;
                              setState(() {
                                gender = selectedGender;
                              });
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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GestureDetector(
                      onTap: isValid
                          ? () async {
                              // 회원 등록 요청
                              final resp = await ref
                                  .read(userInfoProvider.notifier)
                                  .register(
                                    nickname: nicknameController.text,
                                    sex: gender!,
                                    birthday: birthday!,
                                  );

                              // 중복된 닉네임인 경우 다이얼로그 표시
                              // 다른 에러인 경우 provider 내에서 UserModelError로 처리되어 로그인 화면으로 이동됨
                              if (!resp.success &&
                                  resp.errorCode ==
                                      CustomErrorCode
                                          .nicknameAlreadyExistsCode &&
                                  context.mounted) {
                                // 닉네임 중복시 에러 다이얼로그
                                showInfoDialog(
                                  context: context,
                                  content: '이미 존재하는 닉네임이에요',
                                  details: '다른 닉네임을 사용해주세요',
                                );

                                ref
                                    .read(nickNameValidationProvider(formKey)
                                        .notifier)
                                    .setAlreadyExistNickName(
                                      nicknameController.text,
                                    );
                              }
                            }
                          : null,
                      child: CustomSelectButton(
                        content: '다음',
                        backgroundColor:
                            isValid ? ColorName.gray600 : ColorName.gray100,
                        textColor:
                            isValid ? ColorName.white000 : ColorName.gray200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
