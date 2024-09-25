import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class AccountDeletionScreen extends ConsumerStatefulWidget {
  static String get routeName => 'account-deletion';

  const AccountDeletionScreen({super.key});

  @override
  ConsumerState<AccountDeletionScreen> createState() =>
      _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends ConsumerState<AccountDeletionScreen> {
  bool isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayoutWithDefaultAppBar(
      title: '회원탈퇴',
      onBackButtonPressed: () => context.pop(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 48.0, 18.0, 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('정말로 탈퇴하시겠어요?', style: CustomTextStyle.head2()),
              const SizedBox(height: 28.0),
              Text(
                '탈퇴 후에는 서비스 이용에 대한\n모든 권리가 소멸됩니다.',
                style: CustomTextStyle.head4(color: ColorName.gray300),
              ),
              const SizedBox(height: 28.0),
              Text(
                '탈퇴 신청 후, 30일 이후에\n계정 삭제가 완료되며\n복구 및 동일 이메일로 재가입이 불가능합니다.',
                style: CustomTextStyle.head4(color: ColorName.gray300),
              ),
              const SizedBox(height: 24.0),
              Text(
                '작성한 댓글은 삭제되지 않으며\n해당 댓글의 닉네임이 "(알수없음)" 으로\n표시됩니다.',
                style: CustomTextStyle.head4(color: ColorName.gray300),
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => isAgreed = !isAgreed),
                    child: isAgreed
                        ? Assets.icons.svg.icCheckboxEnabled.svg()
                        : Assets.icons.svg.icCheckboxDisabled.svg(),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      '안내사항을 모두 확인하였으며, 이에 동의합니다.',
                      style:
                          CustomTextStyle.body2Medi(color: ColorName.gray500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 53.0),
              Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: const CustomSelectButton(
                        content: '돌아가기',
                      ),
                    ),
                  ),
                  const SizedBox(width: 7.0),
                  Flexible(
                    child: GestureDetector(
                      onTap: isAgreed
                          ? () async {
                              final resp = await ref
                                  .read(userInfoProvider.notifier)
                                  .deleteAccount();

                              if (context.mounted) {
                                if (resp == false) {
                                  showInfoDialog(
                                    context: context,
                                    content: '회원탈퇴에 실패했어요',
                                    details: '잠시 후 다시 시도해주세요',
                                  );
                                  return;
                                }

                                showForceCheckDialog(
                                  context: context,
                                  content: '회원탈퇴가 완료되었어요',
                                  details: '그동안 이용해주셔서 감사합니다',
                                  checkMessage: '확인',
                                  onCheck: () => ref
                                      .read(userInfoProvider.notifier)
                                      .setUserModelToInitial(),
                                );
                              }
                            }
                          : null,
                      child: CustomSelectButton(
                        content: '탈퇴하기',
                        textColor: isAgreed ? null : ColorName.gray200,
                        backgroundColor: isAgreed ? null : ColorName.gray100,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
