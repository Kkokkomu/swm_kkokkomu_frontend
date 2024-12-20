import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/guest_user_explore_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/exploration/provider/logged_in_user_explore_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/cursor_pagination_shortform_view.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ExplorationShortFormScreen extends ConsumerWidget {
  static String get routeName => 'exploration-shortform';

  final int initialPageIndex;

  const ExplorationShortFormScreen({
    super.key,
    this.initialPageIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    late final AutoDisposeStateNotifierProvider<
        CursorPaginationProvider<PaginationShortFormModel,
            IBaseCursorPaginationRepository<PaginationShortFormModel>>,
        CursorPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserExploreShortFormProvider;
    } else {
      provider = guestUserExploreShortFormProvider;
    }

    return CursorPaginationShortFormView(
      shortFormScreenType: ShortFormScreenType.exploration,
      initialPageIndex: initialPageIndex,
      provider: provider,
    );
  }
}
