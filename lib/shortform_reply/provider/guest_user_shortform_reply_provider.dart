import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/model/shortform_reply_additional_params.dart';
import 'package:swm_kkokkomu_frontend/shortform_reply/repository/guest_user_shortform_reply_repository.dart';

final guestUserShortFormReplyProvider = StateNotifierProvider.family
    .autoDispose<GuestUserShortFormReplyStateNotifier, CursorPaginationBase,
        int>(
  (ref, parentCommentId) {
    final shortFormReplyRepository =
        ref.watch(guestUserShortFormReplyRepositoryProvider);

    return GuestUserShortFormReplyStateNotifier(
      shortFormReplyRepository,
      '',
      additionalParams:
          ShortFormReplyAdditionalParams(commentId: parentCommentId),
    );
  },
);

class GuestUserShortFormReplyStateNotifier extends CursorPaginationProvider<
    ShortFormCommentModel, GuestUserShortFormReplyRepository> {
  GuestUserShortFormReplyStateNotifier(
    super.repository,
    super.apiPath, {
    super.additionalParams,
  });
}
