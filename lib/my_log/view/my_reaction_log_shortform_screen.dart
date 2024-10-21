import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_shortform_base.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class MyReactionLogShortFormScreen extends ConsumerWidget {
  static String get routeName => 'my-reaction-log-shortform';

  final int newsId;
  final String shortFormUrl;

  const MyReactionLogShortFormScreen({
    super.key,
    required this.newsId,
    required this.shortFormUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    if (newsId == Constants.unknownErrorId || user is! UserModel) {
      debugPrint('유저의 상태가 올바르지 않거나 newsId 또는 shortFormUrl이 null 값입니다.');

      return CustomShortFormBase(
        shortFormScreenType: ShortFormScreenType.myReactionLog,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.svg.imgEmpty.svg(),
              const SizedBox(height: 6.0),
              Text(
                '에러가 발생했어요\n잠시후 다시 시도해주세요',
                textAlign: TextAlign.center,
                style: CustomTextStyle.body1Medi(
                  color: ColorName.gray200,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleShortForm(
      shortFormScreenType: ShortFormScreenType.myReactionLog,
      newsId: newsId,
      shortFormUrl: shortFormUrl,
    );
  }
}
