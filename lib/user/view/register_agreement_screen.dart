import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/in_app_links.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterAgreementScreen extends ConsumerStatefulWidget {
  static String get routeName => 'register-agreement';

  const RegisterAgreementScreen({super.key});

  @override
  ConsumerState<RegisterAgreementScreen> createState() =>
      _RegisterAgreementScreenState();
}

class _RegisterAgreementScreenState
    extends ConsumerState<RegisterAgreementScreen> {
  bool isMoreThan14Agreed = false;
  bool isTermsOfServiceAgreed = false;
  bool isPrivacyPolicyAgreed = false;

  bool get areAllRequiredTermsAgreed =>
      isMoreThan14Agreed && isTermsOfServiceAgreed && isPrivacyPolicyAgreed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        final resp = await showConfirmationDialog(
          context: context,
          content: '회원 등록을 취소하시겠어요?',
          confirmText: '등록 취소',
          cancelText: '계속하기',
        );

        if (resp == true) {
          ref.read(userInfoProvider.notifier).cancelRegister();
        }
      },
      child: DefaultLayoutWithDefaultAppBar(
        title: '',
        isBottomBorderVisible: false,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: ColorName.white000,
        systemNavigationBarIconBrightness: Brightness.dark,
        onBackButtonPressed: () async {
          final resp = await showConfirmationDialog(
            context: context,
            content: '회원 등록을 취소하시겠어요?',
            confirmText: '등록 취소',
            cancelText: '계속하기',
          );

          if (resp == true) {
            ref.read(userInfoProvider.notifier).cancelRegister();
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28.0),
                Text(
                  '서비스 이용약관에\n동의해주세요',
                  style: CustomTextStyle.head2(),
                ),
                const SizedBox(height: 32.0),
                InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => setState(() {
                    if (areAllRequiredTermsAgreed) {
                      isMoreThan14Agreed = false;
                      isTermsOfServiceAgreed = false;
                      isPrivacyPolicyAgreed = false;
                    } else {
                      isMoreThan14Agreed = true;
                      isTermsOfServiceAgreed = true;
                      isPrivacyPolicyAgreed = true;
                    }
                  }),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: areAllRequiredTermsAgreed
                          ? ColorName.blue100
                          : ColorName.gray50,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 9.0,
                      ),
                      child: Row(
                        children: [
                          areAllRequiredTermsAgreed
                              ? Assets.icons.svg.icCheckboxEnabled.svg()
                              : Assets.icons.svg.icCheckboxDisabled.svg(),
                          const SizedBox(width: 8.0),
                          Text(
                            '모두 동의',
                            style: CustomTextStyle.body2Medi(
                              color: ColorName.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                const Divider(
                  color: ColorName.gray200,
                  thickness: 1.0,
                  height: 1.0,
                ),
                const SizedBox(height: 32.0),
                _TermsWidget(
                  content: '[필수] 만 14세 이상',
                  isAgreed: isMoreThan14Agreed,
                  onTap: () =>
                      setState(() => isMoreThan14Agreed = !isMoreThan14Agreed),
                ),
                _TermsWidget(
                  content: '[필수] 이용약관 동의',
                  isAgreed: isTermsOfServiceAgreed,
                  detailUrl: InAppLinks.termsOfService,
                  onTap: () => setState(
                    () => isTermsOfServiceAgreed = !isTermsOfServiceAgreed,
                  ),
                ),
                _TermsWidget(
                  content: '[필수] 개인정보 처리방침 동의',
                  isAgreed: isPrivacyPolicyAgreed,
                  detailUrl: InAppLinks.privacyPolicy,
                  onTap: () => setState(
                    () => isPrivacyPolicyAgreed = !isPrivacyPolicyAgreed,
                  ),
                ),
                const Spacer(),
                CustomSelectButton(
                  onTap: areAllRequiredTermsAgreed
                      ? () => ref
                          .read(userInfoProvider.notifier)
                          .agreeToTermsForRegister()
                      : null,
                  content: '동의하고 가입하기',
                  backgroundColor: areAllRequiredTermsAgreed
                      ? ColorName.gray600
                      : ColorName.gray100,
                  textColor: areAllRequiredTermsAgreed
                      ? ColorName.white000
                      : ColorName.gray200,
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsWidget extends StatelessWidget {
  final String content;
  final bool isAgreed;
  final String? detailUrl;
  final void Function()? onTap;

  const _TermsWidget({
    required this.content,
    required this.isAgreed,
    this.detailUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: onTap,
      child: Ink(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Row(
            children: [
              isAgreed
                  ? Assets.icons.svg.icCheckEnabled.svg()
                  : Assets.icons.svg.icCheckDisabled.svg(),
              const SizedBox(width: 8.0),
              Text(content),
              if (detailUrl != null) const SizedBox(width: 4.0),
              if (detailUrl != null)
                InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () => launchUrl(Uri.parse(detailUrl!)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '보기',
                      style: CustomTextStyle.detail1Reg(
                        color: ColorName.gray300,
                        decoration: TextDecoration.underline,
                        decorationColor: ColorName.gray300,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
