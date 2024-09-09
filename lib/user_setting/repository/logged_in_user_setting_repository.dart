import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/user_setting/model/user_shortform_category_filter_model.dart';

part 'logged_in_user_setting_repository.g.dart';

final loggedInUserSettingRepositoryProvider =
    Provider<LoggedInUserSettingRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return LoggedInUserSettingRepository(
      dio,
      baseUrl: Constants.baseUrl,
    );
  },
);

@RestApi()
abstract class LoggedInUserSettingRepository {
  factory LoggedInUserSettingRepository(Dio dio, {String baseUrl}) =
      _LoggedInUserSettingRepository;

  @GET('/user-category')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<UserShortFormCategoryFilterModel?>>
      getUserShortFormCategoryFilter();

  @PUT('/user-category')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> updateUserShortFormCategoryFilter({
    @Body() required UserShortFormCategoryFilterModel body,
  });
}
