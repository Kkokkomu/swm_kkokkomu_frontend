import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/offset_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_report_shortform_body_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/put_post_reaction_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/logged_in_user_shortform_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user_setting/provider/logged_in_user_shortform_setting_provider.dart';

final loggedInUserShortFormProvider = StateNotifierProvider.autoDispose<
    LoggedInUserShortFormStateNotifier, OffsetPaginationBase>(
  (ref) {
    final shortFormRepository =
        ref.watch(loggedInUserShortFormRepositoryProvider);
    final userShortFormSetting =
        ref.watch(loggedInUserShortFormSettingProvider);

    return LoggedInUserShortFormStateNotifier(
      shortFormRepository,
      ref: ref,
      additionalParams: ShortFormAdditionalParams(
        category: userShortFormSetting.categoriesToString(),
        filter: userShortFormSetting.shortFormSortType,
      ),
    );
  },
);

class LoggedInUserShortFormStateNotifier extends OffsetPaginationProvider<
    ShortFormModel, LoggedInUserShortFormRepository> {
  final Ref ref;

  LoggedInUserShortFormStateNotifier(
    super.repository, {
    required this.ref,
    super.additionalParams,
  });

  Future<bool> putPostReaction({
    required int newsId,
    required int newsIndex,
    required ReactionType reactionType,
    required bool isReacted,
  }) async {
    final prevState = _getValidPrevState(newsId: newsId);

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) return false;

    // 이전 상태가 유효한 경우 이전 유저 반응 정보 저장
    final prevReaction =
        prevState.items[newsIndex].userReaction.getReactionType();

    // 새 ReactionCnt 개수 설정
    final nextLikeCnt = prevState.items[newsIndex].reactionCnt.like +
        (prevReaction == ReactionType.like ? -1 : 0) +
        (reactionType == ReactionType.like ? 1 : 0);

    final nextAngryCnt = prevState.items[newsIndex].reactionCnt.angry +
        (prevReaction == ReactionType.angry ? -1 : 0) +
        (reactionType == ReactionType.angry ? 1 : 0);

    final nextSurpriseCnt = prevState.items[newsIndex].reactionCnt.surprise +
        (prevReaction == ReactionType.surprise ? -1 : 0) +
        (reactionType == ReactionType.surprise ? 1 : 0);

    final nextSadCnt = prevState.items[newsIndex].reactionCnt.sad +
        (prevReaction == ReactionType.sad ? -1 : 0) +
        (reactionType == ReactionType.sad ? 1 : 0);

    // 현 상태에 맞게 Reaction 정보 업데이트
    prevState.items[newsIndex] = prevState.items[newsIndex].copyWith(
      reactionCnt: prevState.items[newsIndex].reactionCnt.copyWith(
        like: nextLikeCnt,
        angry: nextAngryCnt,
        surprise: nextSurpriseCnt,
        sad: nextSadCnt,
      ),
      userReaction:
          ShortFormUserReactionInfo.createByReactionType(reactionType),
    );

    // 상태 업데이트
    state = prevState.copyWith();

    // 서버에 반응 정보 전송
    // isReacted가 true인 경우 updateReaction, false인 경우 postReaction 요청
    // 즉, isReacted가 true인 경우 이전에 반응을 했던 경우이므로 updateReaction 요청
    final resp = switch (isReacted) {
      true => await repository.updateReaction(
          body: PutPostReactionModel(
            newsId: newsId,
            reaction: reactionType,
          ),
        ),
      false => await repository.postReaction(
          body: PutPostReactionModel(
            newsId: newsId,
            reaction: reactionType,
          ),
        ),
    };

    // 서버 요청 실패 시 false 반환
    if (resp.success != true || resp.data == null) {
      return false;
    }

    // 서버 요청 성공 시 true 반환
    return true;
  }

  Future<bool> deleteReaction({
    required int newsId,
    required int newsIndex,
    required ReactionType reactionType,
  }) async {
    final prevState = _getValidPrevState(newsId: newsId);

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) return false;

    // 이전 상태가 유효한 경우 유저 반응 정보 삭제
    prevState.items[newsIndex] = prevState.items[newsIndex].copyWith(
      reactionCnt: prevState.items[newsIndex].reactionCnt.copyWith(
        like: prevState.items[newsIndex].reactionCnt.like +
            (reactionType == ReactionType.like ? -1 : 0),
        angry: prevState.items[newsIndex].reactionCnt.angry +
            (reactionType == ReactionType.angry ? -1 : 0),
        surprise: prevState.items[newsIndex].reactionCnt.surprise +
            (reactionType == ReactionType.surprise ? -1 : 0),
        sad: prevState.items[newsIndex].reactionCnt.sad +
            (reactionType == ReactionType.sad ? -1 : 0),
      ),
      userReaction: ShortFormUserReactionInfo(),
    );

    // 상태 업데이트
    state = prevState.copyWith();

    // 서버에 삭제 정보 전송
    final resp = await repository.deleteReaction(
      newsId: newsId,
      reaction: reactionType.name.toLowerCase(),
    );

    // 서버 요청 실패 시 false 반환
    if (resp.success != true) {
      return false;
    }

    // 서버 요청 성공 시 true 반환
    return true;
  }

  Future<({bool success, String? errorCode, String? errorMessage})>
      reportShortForm({
    required int newsId,
    required ShortFormReportType reason,
  }) async {
    final prevState = _getValidPrevState(newsId: newsId);

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) {
      return (
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '신고에 실패했습니다.'
      );
    }

    // 이전 상태가 유효한 경우 서버에 신고 요청 전송
    final resp = await repository.reportShortForm(
      body: PostReportShortFormBodyModel(
        reason: reason,
        newsId: newsId,
      ),
    );

    // success값이 true가 아니거나 신고된 뉴스 정보가 없는 경우 실패 처리
    if (resp.success != true || resp.data == null) {
      return (
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '신고에 실패했습니다.',
      );
    }

    return (success: true, errorCode: null, errorMessage: null);
  }

  Future<({bool success, String? errorCode, String? errorMessage})>
      setNotInterested({
    required int newsId,
  }) async {
    final prevState = _getValidPrevState(newsId: newsId);

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) {
      return (
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '관심없음 처리에 실패했습니다.'
      );
    }

    // 이전 상태가 유효한 경우 관심없음 요청 전송
    final resp = await repository.setNotInterested(
      body: PostNewsIdBody(newsId: newsId),
    );

    // success값이 true가 아니거나 관심없음 처리된 정보가 없는 경우 실패 처리
    if (resp.success != true || resp.data == null) {
      return (
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '관심없음 처리에 실패했습니다.'
      );
    }

    return (success: true, errorCode: null, errorMessage: null);
  }

  // 숏폼 관련 요청이 유효한지 확인 후, 유효한 경우 previousState 반환
  OffsetPagination<ShortFormModel>? _getValidPrevState({
    required int newsId,
  }) =>
      // 이전 상태가 OffsetPagination(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이며
      // 뉴스 ID가 알 수 없는 값이 아닌 경우 유효한 상태로 간주
      state is OffsetPagination<ShortFormModel> &&
              ref.read(userInfoProvider) is UserModel &&
              (newsId != Constants.unknownErrorId)
          ? state as OffsetPagination<ShortFormModel>
          : null;
}
