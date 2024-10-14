import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/cursor_pagination_shortform_view.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/guest_user_search_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_search/provider/logged_in_user_search_shortform_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

class ShortFormSearchedScreen extends ConsumerWidget {
  static String get routeName => 'shortform-searched';

  final String searchKeyword;
  final int initialPageIndex;

  const ShortFormSearchedScreen({
    super.key,
    required this.searchKeyword,
    required this.initialPageIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoProvider);

    late final AutoDisposeStateNotifierProvider<
        CursorPaginationProvider<PaginationShortFormModel,
            IBaseCursorPaginationRepository<PaginationShortFormModel>>,
        CursorPaginationBase> provider;

    if (user is UserModel) {
      provider = loggedInUserSearchShortFormProvider(searchKeyword);
    } else {
      provider = guestUserSearchShortFormProvider(searchKeyword);
    }

    return CursorPaginationShortFormView(
      shortFormScreenType: ShortFormScreenType.shortFormSearched,
      initialPageIndex: initialPageIndex,
      provider: provider,
    );
  }
}
