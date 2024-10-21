import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/home_shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_pagination_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';

final loggedInUserHomeShortFormProvider = StateNotifierProvider.autoDispose<
    LoggedInUserPaginationShortFormStateNotifier, CursorPaginationBase>(
  (ref) {
    final shortFormPaginationRepository =
        ref.watch(loggedInUserPaginationShortFormRepositoryProvider);
    final userShortFormSetting =
        ref.watch(loggedInUserShortFormSettingProvider);

    return LoggedInUserPaginationShortFormStateNotifier(
      shortFormPaginationRepository,
      '/home/news/list',
      ref: ref,
      additionalParams: HomeShortFormAdditionalParams(
        filter: userShortFormSetting.shortFormSortType,
      ),
    );
  },
);

class LoggedInUserPaginationShortFormStateNotifier
    extends CursorPaginationProvider<PaginationShortFormModel,
        LoggedInUserPaginationShortFormRepository> {
  final Ref ref;

  LoggedInUserPaginationShortFormStateNotifier(
    super.repository,
    super.apiPath, {
    required this.ref,
    super.additionalParams,
  });

  // Item 리스트에서 특정 숏폼 삭제
  bool deleteShortFormByNewsId(int newsId) {
    // 숏폼 삭제 전 상태를 저장
    final prevState = _getValidPrevState();

    if (prevState == null) {
      return false;
    }

    // 숏폼 삭제 요청
    prevState.items.removeWhere((element) => element.newsId == newsId);

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // Item 리스트에 특정 숏폼 추가
  bool addShortForm(PaginationShortFormModel shortForm) {
    // 숏폼 추가 전 상태를 저장
    final prevState = _getValidPrevState();

    if (prevState == null) {
      return false;
    }

    // 숏폼 추가
    prevState.items.insert(0, shortForm);

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // Item 리스트에서 특정 숏폼의 reactionType 변경
  bool updateShortFormReactionType({
    required int newsId,
    required ReactionType newReactionType,
  }) {
    // 숏폼 업데이트 전 상태를 저장
    final prevState = _getValidPrevState();

    if (prevState == null) {
      return false;
    }

    // prevState.Items에서 newsId와 일치하는 뉴스의 reactionType 변경
    final targetShortFormIndex =
        prevState.items.indexWhere((element) => element.newsId == newsId);

    if (targetShortFormIndex == -1) {
      return false;
    }

    prevState.items[targetShortFormIndex] =
        prevState.items[targetShortFormIndex].copyWith(
      userReaction:
          ShortFormUserReactionInfo.createByReactionType(newReactionType),
    );

    // 상태 반영
    state = prevState.copyWith();

    return true;
  }

  // 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  CursorPagination<PaginationShortFormModel>? _getValidPrevState() =>
      // 이전 상태가 CursorPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)인 경우
      // 유효한 상태로 간주
      state is CursorPagination<PaginationShortFormModel> &&
              ref.read(userInfoProvider) is UserModel
          ? state as CursorPagination<PaginationShortFormModel>
          : null;
}
