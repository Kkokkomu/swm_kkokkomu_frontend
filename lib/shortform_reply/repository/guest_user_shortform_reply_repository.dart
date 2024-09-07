import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/additional_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_params.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/model/shortform_comment_model.dart';

part 'guest_user_shortform_reply_repository.g.dart';

final guestUserShortFormReplyRepositoryProvider =
    Provider<GuestUserShortFormReplyRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return GuestUserShortFormReplyRepository(
    dio,
    baseUrl: '${Constants.baseUrl}/comment/reply/oldest/guest',
  );
});

@RestApi()
abstract class GuestUserShortFormReplyRepository
    implements IBaseCursorPaginationRepository<ShortFormCommentModel> {
  factory GuestUserShortFormReplyRepository(Dio dio, {String baseUrl}) =
      _GuestUserShortFormReplyRepository;

  @override
  @GET('')
  Future<ResponseModel<CursorPagination<ShortFormCommentModel>>> paginate(
    @Queries() CursorPaginationParams cursorPaginationParams, {
    @Queries() AdditionalParams? additionalParams,
    @Path() String apiPath = '',
  });
}
