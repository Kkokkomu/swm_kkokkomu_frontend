import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_show_dialog.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout.dart';
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

    return DefaultLayout(
      statusBarBrightness: Brightness.dark,
      titleWidget: const Text('차단 유저 관리'),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: switch (blockedUserList) {
            // 차단된 유저 리스트를 받아오는 중일때
            HidedUserModelLoading() => const Center(
                child: CustomCircularProgressIndicator(),
              ),

            // 차단된 유저 리스트를 받아오는 중 에러가 발생한 경우
            HidedUserModelError() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('차단된 유저 목록을 불러오는데 실패했습니다.'),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(loggedInUserBlockedUserListProvider.notifier)
                          .getHidedUserList(),
                      child: const Text('재시도'),
                    ),
                  ],
                ),
              ),

            // 차단된 유저 리스트를 정상적으로 받아온 경우
            HidedUserModel() => blockedUserList.hidedUserList.isEmpty
                ? const Center(
                    child: Text('차단된 유저가 없습니다.'),
                  )
                : ListView.separated(
                    itemCount: blockedUserList.hidedUserList.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      return ListTile(
                        title:
                            Text(blockedUserList.hidedUserList[index].userName),
                        subtitle: Text(
                          '차단일시: ${blockedUserList.hidedUserList[index].createdAt}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final isDelete = await showConfirmationDialog(
                              context: context,
                              content: '정말 차단을 해제하시겠습니까?',
                              confirmText: '해제',
                              cancelText: '취소',
                            );

                            // 사용자가 확인을 누르지 않은 경우
                            if (isDelete != true) return;

                            final resp = await ref
                                .read(
                                  loggedInUserBlockedUserListProvider.notifier,
                                )
                                .unHideUser(
                                  blockedUserList.hidedUserList[index].id,
                                );

                            // 차단 해제에 실패한 경우
                            if (resp != true) {
                              CustomToastMessage.showErrorToastMessage(
                                  '차단 해제에 실패했습니다');
                              return;
                            }

                            // 차단 해제에 성공한 경우
                            CustomToastMessage.showSuccessToastMessage(
                              '차단이 해제되었습니다',
                            );
                          },
                        ),
                      );
                    },
                  ),
          }),
    );
  }
}
