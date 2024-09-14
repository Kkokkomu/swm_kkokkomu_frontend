import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/offset_pagination_page_view.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/bottom_navigation_bar_state_provider.dart';
import 'package:swm_kkokkomu_frontend/common/provider/offset_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_offset_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormScreen extends ConsumerWidget {
  static String get routeName => 'shortform';

  const ShortFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);
    final bottomNavigationBarState =
        ref.watch(bottomNavigationBarStateProvider);

    late final AutoDisposeStateNotifierProvider<
        OffsetPaginationProvider<ShortFormModel,
            BaseOffsetPaginationRepository<ShortFormModel>>,
        OffsetPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserShortFormProvider;
    } else {
      provider = guestUserShortFormProvider;
    }

    return OffsetPaginationPageView<ShortFormModel>(
      provider: provider,
      // 바텀 네비게이션바가 보이고 모달 배리어가 보이지 않을 때만 스크롤 가능하도록 설정
      // 댓글 창이 활성화 된 경우 -> 바텀 네비게이션바가 보이지 않음 -> 스크롤 불가능
      // 감정입력창이 활성화 된 경우 -> 모달 배리어가 보임 -> 스크롤 불가능
      scrollPhysics: (bottomNavigationBarState.isBottomNavigationBarVisible &&
              !bottomNavigationBarState.isModalBarrierVisible)
          ? const CustomScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index, model) {
        final newsInfo = model.info.news;
        final reactionCountInfo = model.reactionCnt;
        final userReactionType = model.userReaction.getReactionType();

        if (newsInfo.id == Constants.unknownErrorId ||
            newsInfo.shortformUrl == null) {
          debugPrint('newsId 또는 shortFormUrl이 null 값입니다.');

          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '비디오 에러 발생\n다음 비디오로 넘어가주세요.',
                style: TextStyle(
                  color: ColorName.white000,
                ),
              ),
            ],
          );
        }

        return SingleShortForm(
          newsId: newsInfo.id,
          newsIndex: index,
          shortFormUrl: newsInfo.shortformUrl!,
          newsInfo: newsInfo,
          keywords: model.info.keywords,
          reactionCountInfo: reactionCountInfo,
          userReactionType: userReactionType,
        );
      },
    );
  }
}
