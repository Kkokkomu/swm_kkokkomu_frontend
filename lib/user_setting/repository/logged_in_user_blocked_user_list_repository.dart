import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/hide_user_response_data_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/hided_user_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/post_hide_user_model.dart';

part 'logged_in_user_blocked_user_list_repository.g.dart';

final loggedInUserBlockedUserListRepositoryProvider =
    Provider<LoggedInUserBlockedUserListRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return LoggedInUserBlockedUserListRepository(
      dio,
      baseUrl: '${Constants.baseUrl}/hide-user',
    );
  },
);

@RestApi()
abstract class LoggedInUserBlockedUserListRepository {
  factory LoggedInUserBlockedUserListRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserBlockedUserListRepository;

  @POST('')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<HideUserResponseDataModel?>> hideUser({
    @Body() required PostHideUserModel body,
  });

  @DELETE('')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> unHideUser({
    @Query('hiddenId') required int hiddenId,
  });

  @GET('/list')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<List<HidedUserData>?>> getHidedUserList();
}
