import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_close_button.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_grabber.dart';
import 'package:swm_kkokkomu_frontend/common/component/custom_select_button.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/layout/default_layout_with_default_app_bar.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/detail_user_info_provider.dart';

class ProfileScreen extends ConsumerWidget {
  static String get routeName => 'profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailUserInfo = ref.watch(detailUserInfoProvider);

    return DefaultLayoutWithDefaultAppBar(
      statusBarBrightness: Brightness.dark,
      title: '내 정보',
      onBackButtonPressed: () => context.pop(),
      titleActions: detailUserInfo is DetailUserModel
          ? [
              TextButton(
                onPressed: () => context.go(CustomRoutePath.editPersonalInfo),
                child: Text(
                  '수정',
                  style: CustomTextStyle.body2Bold(color: ColorName.blue500),
                ),
              ),
              const SizedBox(width: 4.0),
            ]
          : null,
      child: switch (detailUserInfo) {
        DetailUserModelLoading() => const Center(
            child: CustomCircularProgressIndicator(),
          ),
        DetailUserModelError() => Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '유저 정보를 불러오는데 실패했어요',
                        style: CustomTextStyle.body2Reg(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),
                  CustomSelectButton(
                    content: '다시 시도',
                    onTap: () => ref
                        .read(detailUserInfoProvider.notifier)
                        .getDetailUserInfo(),
                  ),
                ],
              ),
            ),
          ),
        DetailUserModel() => SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32.0),
                Center(
                  child: GestureDetector(
                    onTap: () => showProfileImgSettingBottomSheet(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: SizedBox(
                            width: 92.0,
                            height: 92.0,
                            child: Image.network(
                              detailUserInfo.profileUrl != null
                                  ? '${detailUserInfo.profileUrl}?profileEditedAt=${detailUserInfo.profileEditedAt}'
                                  : '',
                              fit: BoxFit.cover,
                              cacheWidth: (92.0 *
                                      MediaQuery.of(context).devicePixelRatio)
                                  .round(),
                              loadingBuilder: (_, child, loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : Skeletonizer(
                                          child: Container(
                                            color: ColorName.gray50,
                                            width: 92.0,
                                            height: 92.0,
                                          ),
                                        ),
                              errorBuilder: (_, __, ___) => Container(
                                color: ColorName.gray50,
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -8.0,
                          right: -8.0,
                          child: Assets.icons.svg.btnProfileEdit.svg(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '닉네임',
                            style: CustomTextStyle.body1Bold(),
                          ),
                          const Spacer(),
                          Text(
                            detailUserInfo.nickname,
                            style: CustomTextStyle.body1Reg(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 27.0),
                      Row(
                        children: [
                          Text(
                            '출생연도',
                            style: CustomTextStyle.body1Bold(),
                          ),
                          const Spacer(),
                          Text(
                            detailUserInfo.birthday.year ==
                                    Constants.birthYearNotSelected
                                ? '선택안함'
                                : '${detailUserInfo.birthday.year}년',
                            style: CustomTextStyle.body1Reg(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 27.0),
                      Row(
                        children: [
                          Text(
                            '성별',
                            style: CustomTextStyle.body1Bold(),
                          ),
                          const Spacer(),
                          Text(
                            detailUserInfo.sex.label,
                            style: CustomTextStyle.body1Reg(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => context.go(CustomRoutePath.accountDeletion),
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ColorName.gray200,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '탈퇴하기',
                          style: CustomTextStyle.detail2Reg(
                            color: ColorName.gray200,
                          ),
                        ),
                        Assets.icons.svg.icUnsubscribe.svg(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
      },
    );
  }
}

Future<dynamic> showProfileImgSettingBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) => Container(
      height: 238.0 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: ColorName.white000,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5.5),
          const CustomGrabber(),
          const SizedBox(height: 4.0),
          Row(
            children: [
              const SizedBox(width: 18.0),
              Text(
                '프로필 변경',
                style: CustomTextStyle.head3(),
              ),
              const Spacer(),
              const CustomCloseButton(),
              const SizedBox(width: 4.0),
            ],
          ),
          const SizedBox(height: 14.0),
          Consumer(
            builder: (_, ref, __) => Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      ref
                          .read(detailUserInfoProvider.notifier)
                          .updateUserProfileImg(ImageSource.gallery);

                      if (context.mounted) context.pop();
                    },
                    child: SizedBox(
                      height: 48.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 18.0),
                            Assets.icons.svg.icPhoto.svg(),
                            const SizedBox(width: 12.0),
                            Text(
                              '라이브러리에서 선택하기',
                              style: CustomTextStyle.body1Medi(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      ref
                          .read(detailUserInfoProvider.notifier)
                          .updateUserProfileImg(ImageSource.camera);

                      if (context.mounted) context.pop();
                    },
                    child: SizedBox(
                      height: 48.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 18.0),
                            Assets.icons.svg.icCamera.svg(),
                            const SizedBox(width: 12.0),
                            Text(
                              '사진 찍기',
                              style: CustomTextStyle.body1Medi(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      ref
                          .read(detailUserInfoProvider.notifier)
                          .updateUserProfileImgToDefault();

                      if (context.mounted) context.pop();
                    },
                    child: SizedBox(
                      height: 48.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 18.0),
                            Assets.icons.svg.icFolder.svg(),
                            const SizedBox(width: 12.0),
                            Text(
                              '기본 이미지로 설정하기',
                              style: CustomTextStyle.body1Medi(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
