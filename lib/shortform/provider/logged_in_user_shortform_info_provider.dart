import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/my_log/provider/my_reaction_log_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_report_shortform_body_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/put_post_reaction_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_info_repository.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';

final loggedInUserShortFormInfoProvider = StateNotifierProvider.autoDispose
    .family<LoggedInUserShortFormInfoStateNotifier, ShortFormModelBase, int>(
  (ref, newsId) {
    final shortFormInfoRepository = ref.watch(shortFormInfoRepositoryProvider);

    return LoggedInUserShortFormInfoStateNotifier(
      ref: ref,
      repository: shortFormInfoRepository,
      newsId: newsId,
    );
  },
);

class LoggedInUserShortFormInfoStateNotifier
    extends StateNotifier<ShortFormModelBase> {
  final Ref ref;
  final ShortFormInfoRepository repository;
  final int newsId;

  LoggedInUserShortFormInfoStateNotifier({
    required this.ref,
    required this.repository,
    required this.newsId,
  }) : super(ShortFormModelLoading()) {
    getShortFormInfo();
  }

  /// 뉴스 정보 요청
  Future<void> getShortFormInfo() async {
    state = ShortFormModelLoading();

    // 서버에 뉴스 정보 요청
    final resp = await repository.getNewsInfoForLoggedInUser(newsId: newsId);

    // 서버 요청 실패 시 에러 처리
    if (resp.success != true || resp.data == null) {
      state = ShortFormModelError('뉴스 정보를 불러오는 중 에러가 발생했어요\n다시 시도해주세요');
      return;
    }

    // 서버 요청 성공 시 상태 업데이트
    if (mounted) state = resp.data!;
  }

  /// 감정 표현 추가/수정
  Future<bool> putPostReaction({
    required ReactionType reactionType,
    required bool isReacted,
  }) async {
    final prevState = _getValidPrevState();

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) return false;

    // 이전 상태가 유효한 경우 이전 유저 반응 정보 저장
    final prevReaction = prevState.userReaction.getReactionType();

    // 새 ReactionCnt 개수 설정
    final nextLikeCnt = prevState.reactionCnt.like +
        (prevReaction == ReactionType.like ? -1 : 0) +
        (reactionType == ReactionType.like ? 1 : 0);

    final nextAngryCnt = prevState.reactionCnt.angry +
        (prevReaction == ReactionType.angry ? -1 : 0) +
        (reactionType == ReactionType.angry ? 1 : 0);

    final nextSurpriseCnt = prevState.reactionCnt.surprise +
        (prevReaction == ReactionType.surprise ? -1 : 0) +
        (reactionType == ReactionType.surprise ? 1 : 0);

    final nextSadCnt = prevState.reactionCnt.sad +
        (prevReaction == ReactionType.sad ? -1 : 0) +
        (reactionType == ReactionType.sad ? 1 : 0);

    // 현 상태에 맞게 Reaction 정보 업데이트
    state = prevState.copyWith(
      reactionCnt: prevState.reactionCnt.copyWith(
        like: nextLikeCnt,
        angry: nextAngryCnt,
        surprise: nextSurpriseCnt,
        sad: nextSadCnt,
      ),
      userReaction:
          ShortFormUserReactionInfo.createByReactionType(reactionType),
    );

    // myReactionLogProvider가 초기화 된 경우 유저 리액션 로그에 감정표현 추가된 뉴스 삽입
    // isReacted가 false인 경우 이전에 반응을 하지 않았던 경우이므로 삽입
    if (ref.exists(myReactionLogProvider)) {
      if (!isReacted) {
        ref.read(myReactionLogProvider.notifier).addShortForm(
              PaginationShortFormModel(
                info: prevState.info,
                reactionCnt: prevState.reactionCnt.copyWith(
                  like: nextLikeCnt,
                  angry: nextAngryCnt,
                  surprise: nextSurpriseCnt,
                  sad: nextSadCnt,
                ),
                userReaction: ShortFormUserReactionInfo.createByReactionType(
                  reactionType,
                ),
              ),
            );
      } else {
        ref.read(myReactionLogProvider.notifier).updateShortFormReactionType(
              newsId: newsId,
              newReactionType: reactionType,
            );
      }
    }

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

  /// 감정 표현 삭제
  Future<bool> deleteReaction({
    required ReactionType reactionType,
  }) async {
    final prevState = _getValidPrevState();

    // 이전 상태가 유효하지 않은 경우 false 반환
    if (prevState == null) return false;

    // 이전 상태가 유효한 경우 유저 반응 정보 삭제
    state = prevState.copyWith(
      reactionCnt: prevState.reactionCnt.copyWith(
        like: prevState.reactionCnt.like +
            (reactionType == ReactionType.like ? -1 : 0),
        angry: prevState.reactionCnt.angry +
            (reactionType == ReactionType.angry ? -1 : 0),
        surprise: prevState.reactionCnt.surprise +
            (reactionType == ReactionType.surprise ? -1 : 0),
        sad: prevState.reactionCnt.sad +
            (reactionType == ReactionType.sad ? -1 : 0),
      ),
      userReaction: ShortFormUserReactionInfo(),
    );

    // myReactionLogProvider 가 초기화 된 경우 유저 리액션 로그에서 감정표현 해제한 뉴스를 삭제
    if (ref.exists(myReactionLogProvider)) {
      ref.read(myReactionLogProvider.notifier).deleteShortFormByNewsId(newsId);
    }

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

  /// 숏폼 신고
  Future<({bool success, String? errorCode, String? errorMessage})>
      reportShortForm({
    required ShortFormReportType reason,
  }) async {
    final prevState = _getValidPrevState();

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

    // 성공 시 true 반환
    return (success: true, errorCode: null, errorMessage: null);
  }

  /// 관심없음 처리
  Future<({bool success, String? errorCode, String? errorMessage})>
      setNotInterested() async {
    final prevState = _getValidPrevState();

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

    // 성공 시 true 반환
    return (success: true, errorCode: null, errorMessage: null);
  }

  /// 현재 상태가 유효한지 확인 후, 유효한 경우 prevState 반환
  ShortFormModel? _getValidPrevState() =>
      // 이전 상태가 ShortFormModel(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이며
      // 뉴스 ID가 알 수 없는 값이 아닌 경우 유효한 상태로 간주
      state is ShortFormModel &&
              ref.read(userInfoProvider) is UserModel &&
              newsId != Constants.unknownErrorId
          ? state as ShortFormModel
          : null;
}
