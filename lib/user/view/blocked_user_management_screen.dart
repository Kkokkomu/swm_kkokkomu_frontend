import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/hided_user_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_blocked_user_list_provider.dart';

class BlockedUserManagementScreen extends ConsumerStatefulWidget {
  static String get routeName => 'blocked-user-management';

  const BlockedUserManagementScreen({super.key});

  @override
  ConsumerState<BlockedUserManagementScreen> createState() =>
      _BlockedUserManagementScreenState();
}

class _BlockedUserManagementScreenState
    extends ConsumerState<BlockedUserManagementScreen> {
  @override
  void initState() {
    super.initState();
    // 최초에 1번 차단된 유저 목록을 불러옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loggedInUserBlockedUserListProvider.notifier).getHidedUserList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blockedUserList = ref.watch(loggedInUserBlockedUserListProvider);

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      title: '차단 목록',
      onBackButtonPressed: () => context.pop(),
      child: switch (blockedUserList) {
        // 차단된 유저 리스트를 받아오는 중일때
        HidedUserModelLoading() => const Center(
            child: CustomCircularProgressIndicator(),
          ),

        // 차단된 유저 리스트를 받아오는 중 에러가 발생한 경우
        HidedUserModelError() => SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Assets.images.svg.imgLogo.svg(),
                  const SizedBox(height: 6.0),
                  Text(
                    '차단한 유저 목록을 불러오는데 실패했어요',
                    style: CustomTextStyle.body1Medi(
                      color: ColorName.gray200,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomSelectButton(
                      onTap: () => ref
                          .read(loggedInUserBlockedUserListProvider.notifier)
                          .getHidedUserList(),
                      content: '재시도',
                      backgroundColor: ColorName.gray100,
                      textColor: ColorName.gray300,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 차단된 유저 리스트를 정상적으로 받아온 경우
        HidedUserModel() => blockedUserList.hidedUserList.isEmpty
            ? SafeArea(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.images.svg.imgLogo.svg(),
                      const SizedBox(height: 6.0),
                      Text(
                        '차단한 사용자가 없어요',
                        style: CustomTextStyle.body1Medi(
                          color: ColorName.gray200,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: ListView.separated(
                            itemCount: blockedUserList.hidedUserList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 4.0),
                            itemBuilder: (_, index) {
                              final hidedUser =
                                  blockedUserList.hidedUserList[index];

                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0.0,
                                  index == 0 ? 21.0 : 9.0,
                                  0.0,
                                  9.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: ColorName.gray200,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          hidedUser.profileImg,
                                          loadingBuilder:
                                              (_, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }

                                            return Skeletonizer(
                                              child: Container(
                                                width: 40.0,
                                                height: 40.0,
                                                color: ColorName.gray100,
                                              ),
                                            );
                                          },
                                          errorBuilder: (_, __, ___) => Assets
                                              .images.svg.imgProfileDefault
                                              .svg(
                                            width: 40.0,
                                            height: 40.0,
                                          ),
                                          fit: BoxFit.cover,
                                          height: 40.0,
                                          width: 40.0,
                                          cacheWidth: (40.0 *
                                                  MediaQuery.of(context)
                                                      .devicePixelRatio)
                                              .round(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hidedUser.userName,
                                          style: CustomTextStyle.body2Bold(),
                                        ),
                                        Text(
                                          '차단일 : ${DateFormat('yyyy.MM.dd', 'ko_KR').format(hidedUser.createdAt)}',
                                          style: CustomTextStyle.detail1Reg(
                                            color: ColorName.gray400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(20.0),
                                      onTap: () async {
                                        final isDelete =
                                            await showConfirmationDialog(
                                          context: context,
                                          content: '정말 차단을 해제하시겠어요?',
                                          details: '해당 사용자의 댓글이 다시 보여요',
                                          confirmText: '해제',
                                          cancelText: '취소',
                                        );

                                        // 사용자가 확인을 누르지 않은 경우
                                        if (isDelete != true) return;

                                        final resp = await ref
                                            .read(
                                              loggedInUserBlockedUserListProvider
                                                  .notifier,
                                            )
                                            .unHideUser(
                                              blockedUserList
                                                  .hidedUserList[index].id,
                                            );

                                        // 차단 해제에 실패한 경우
                                        if (resp != true) {
                                          CustomToastMessage
                                              .showErrorToastMessage(
                                            '차단 목록 수정에 실패했어요',
                                          );
                                          return;
                                        }

                                        // 차단 해제에 성공한 경우
                                        CustomToastMessage
                                            .showSuccessToastMessage(
                                          '차단 목록이 수정되었어요',
                                        );
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          color: ColorName.blue100,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 6.0,
                                            ),
                                            child: Text(
                                              '차단해제',
                                              style: CustomTextStyle.detail1Reg(
                                                color: ColorName.blue500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      },
    );
  }
}
