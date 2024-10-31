import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/provider/deep_link_provider.dart';
import 'package:swm_kkokkomu_frontend/common/fcm/push_notification_service.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/cursor_pagination_shortform_view.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_home_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormScreen extends ConsumerStatefulWidget {
  static String get routeName => 'shortform';

  const ShortFormScreen({super.key});

  @override
  ConsumerState<ShortFormScreen> createState() => _ShortFormScreenState();
}

class _ShortFormScreenState extends ConsumerState<ShortFormScreen> {
  @override
  void initState() {
    super.initState();
    // 알림 권한 요청
    // 이미 권한이 허용/거부된 경우, 다이얼로그가 뜨지 않음
    ref.read(pushNotificationServiceProvider).requestPermission();

    // 최초 홈 화면 진입 시, 최초 딥링크 값이 설정되어 있는 경우 최초 딥링크 실행
    // FCM 푸시 알림을 통해 앱이 실행된 경우에 실행됨
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(deeplinkProvider.notifier).executeInitialDeepLink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoProvider);

    late final AutoDisposeStateNotifierProvider<
        CursorPaginationProvider<PaginationShortFormModel,
            IBaseCursorPaginationRepository<PaginationShortFormModel>>,
        CursorPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserHomeShortFormProvider;
    } else {
      provider = guestUserHomeShortFormProvider;
    }

    return Container(
      color: Colors.black,
      child: CursorPaginationShortFormView(
        shortFormScreenType: ShortFormScreenType.home,
        provider: provider,
      ),
    );
  }
}
