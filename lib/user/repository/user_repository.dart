import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/dio/dio.dart';
import 'package:swm_kkokkomu_frontend/common/model/response_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/post_update_fcm_token_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/put_user_notification_setting_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/put_user_profile_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/update_fcm_token_response_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return UserRepository(
      dio,
      baseUrl: Constants.baseUrl,
    );
  },
);

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/user')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<DetailUserModel?>> getDetailUserInfo();

  @PUT('/user/alarmSetting')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<DetailUserModel?>> updateUserNotificationSetting({
    @Body() required PutUserNotificationSettingBody setting,
  });

  @POST('/alarm/token')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<UpdateFcmTokenResponseModel?>> updateFcmToken({
    @Body() required PostUpdateFcmTokenBody body,
  });

  @DELETE('/alarm/token')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteFcmToken({
    @Query('fcmToken') required String fcmToken,
  });

  @PUT('/user/img')
  @Headers({
    'accessToken': true,
  })
  @MultiPart()
  Future<ResponseModel<DetailUserModel?>> updateUserProfileImg({
    @Part(name: 'image') required File image,
  });

  @PUT('/user/img/default')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<DetailUserModel?>> updateUserProfileImgToDefault();

  @PUT('/user')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<DetailUserModel?>> updateUserPersonalInfo({
    @Body() required PutUserProfileBody personalInfo,
  });

  @GET('/user/mypage')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<UserModel?>> getUserInfo();

  @DELETE('/user/exit')
  @Headers({
    'accessToken': true,
  })
  Future<ResponseModel<String?>> deleteAccount();
}
