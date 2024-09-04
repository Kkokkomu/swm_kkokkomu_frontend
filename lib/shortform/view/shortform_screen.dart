import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/component/offset_pagination_page_view.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
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
    final isBottomNavigationBarVisible = ref.watch(
      bottomNavigationBarStateProvider.select(
        (value) => value.isBottomNavigationBarVisible,
      ),
    );

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
      scrollPhysics: isBottomNavigationBarVisible
          ? const CustomScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __, model) {
        final shortFormUrlInfo = model.shortformList;
        final newsId = shortFormUrlInfo?.id;
        final shortFormUrl = shortFormUrlInfo?.shortformUrl;

        if (shortFormUrlInfo == null ||
            newsId == null ||
            shortFormUrl == null) {
          debugPrint('newsId or shortFormUrl is null');

          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '비디오 에러 발생\n다음 비디오로 넘어가주세요.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          );
        }

        return SingleShortForm(
          newsId: newsId,
          shortFormUrl: shortFormUrl,
          relatedUrl: shortFormUrlInfo.relatedUrl,
        );
      },
    );
  }
}
