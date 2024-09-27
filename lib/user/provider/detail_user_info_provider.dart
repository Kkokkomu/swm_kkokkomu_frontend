import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_error_code.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';
import 'package:swm_kkokkomu_frontend/common/model/provider_response_model.dart';
import 'package:swm_kkokkomu_frontend/common/toast_message/custom_toast_message.dart';
import 'package:swm_kkokkomu_frontend/shortform_comment/provider/shortform_comment_height_controller_provider.dart';
import 'package:swm_kkokkomu_frontend/user/model/detail_user_model.dart';
import 'package:swm_kkokkomu_frontend/user/model/put_user_profile_body.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:swm_kkokkomu_frontend/user/provider/user_info_provider.dart';
import 'package:swm_kkokkomu_frontend/user/repository/user_repository.dart';

final detailUserInfoProvider = StateNotifierProvider.autoDispose<
    DetailUserInfoStateNotifier, DetailUserModelBase>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);

    return DetailUserInfoStateNotifier(
      ref: ref,
      userRepository: userRepository,
    );
  },
);

class DetailUserInfoStateNotifier extends StateNotifier<DetailUserModelBase> {
  final Ref ref;
  final UserRepository userRepository;

  DetailUserInfoStateNotifier({
    required this.ref,
    required this.userRepository,
  }) : super(DetailUserModelLoading()) {
    getDetailUserInfo();
  }

  Future<void> getDetailUserInfo() async {
    // 로딩 상태로 변경
    state = DetailUserModelLoading();

    // 서버로부터 유저 정보 요청
    final resp = await userRepository.getDetailUserInfo();

    final detailInfo = resp.data;

    // 정상적인 응답이 아니라면 에러 상태로 변경
    if (resp.success != true || detailInfo == null) {
      state = DetailUserModelError('유저 정보를 불러오는데 실패했습니다.');
      return;
    }

    // 정상적인 응답이라면 상태 반영
    state = detailInfo;
  }

  Future<bool> updateUserProfileImg(ImageSource imageSource) async {
    final prevState = _getValidPrevState();

    // 이전 상태가 유효하지 않다면 실패 반환
    if (prevState == null) {
      CustomToastMessage.showErrorToastMessage('프로필 사진 변경에 실패했습니다.');
      return false;
    }

    // 이미지 선택
    final image = await ImagePicker().pickImage(source: imageSource);

    // 이미지를 선택하지 않았다면 실패 반환
    if (image == null) {
      return false;
    }

    // 로딩 상태로 변경
    state = DetailUserModelLoading();

    // 서버에 프로필 사진 수정 요청
    final resp = await userRepository.updateUserProfileImg(
      image: File(image.path),
    );

    final respProfile = resp.data;

    // 정상적인 응답이 아니라면 실패 반환
    if (resp.success != true || respProfile == null) {
      CustomToastMessage.showErrorToastMessage('프로필 사진 변경에 실패했습니다.');
      state = prevState;
      return false;
    }

    // 정상적인 응답이라면 상태 반영
    // detailUserInfo와 userInfo 모두 업데이트
    // 댓글창 초기화를 통해 댓글 프로필에도 업데이트 반영
    ref.read(userInfoProvider.notifier).updateUserInfo(respProfile);
    ref.invalidate(shortFormCommentHeightControllerProvider);
    state = respProfile;

    CustomToastMessage.showSuccessToastMessage('프로필 사진이 변경되었습니다.');
    return true;
  }

  Future<bool> updateUserProfileImgToDefault() async {
    final prevState = _getValidPrevState();

    // 이전 상태가 유효하지 않다면 실패 반환
    if (prevState == null) {
      CustomToastMessage.showErrorToastMessage('프로필 사진 변경에 실패했습니다.');
      return false;
    }

    // 로딩 상태로 변경
    state = DetailUserModelLoading();

    // 서버에 프로필 사진 수정 요청
    final resp = await userRepository.updateUserProfileImgToDefault();

    final respProfile = resp.data;

    // 정상적인 응답이 아니라면 실패 반환
    if (resp.success != true || respProfile == null) {
      CustomToastMessage.showErrorToastMessage('프로필 사진 변경에 실패했습니다.');
      state = prevState;
      return false;
    }

    // 정상적인 응답이라면 상태 반영
    // detailUserInfo와 userInfo 모두 업데이트
    // 댓글창 초기화를 통해 댓글 프로필에도 업데이트 반영
    ref.read(userInfoProvider.notifier).updateUserInfo(respProfile);
    ref.invalidate(shortFormCommentHeightControllerProvider);
    state = respProfile;

    CustomToastMessage.showSuccessToastMessage('프로필 사진이 변경되었습니다.');
    return true;
  }

  Future<ProviderResponseModel> updateUserPersonalInfo({
    String? nickname,
    DateTime? birthday,
    GenderType? sex,
  }) async {
    final prevState = _getValidPrevState();

    // 이전 상태가 유효하지 않다면 실패 반환
    if (prevState == null) {
      return ProviderResponseModel(
        success: false,
        errorCode: CustomErrorCode.unknownCode,
        errorMessage: '정보 수정에 실패했어요',
      );
    }

    // 로딩 상태로 변경
    state = DetailUserModelLoading();

    // 서버에 유저 정보 수정 요청
    final resp = await userRepository.updateUserPersonalInfo(
      personalInfo: PutUserProfileBody(
        nickname: nickname ?? prevState.nickname,
        birthday: birthday ?? prevState.birthday,
        sex: sex ?? prevState.sex,
      ),
    );

    final respProfile = resp.data;

    // 정상적인 응답이 아니라면 실패 반환
    if (resp.success != true || respProfile == null) {
      state = prevState;
      return ProviderResponseModel(
        success: false,
        errorCode: resp.error?.code ?? CustomErrorCode.unknownCode,
        errorMessage: resp.error?.message ?? '정보 수정에 실패했어요',
      );
    }

    // 정상적인 응답이라면 상태 반영
    // detailUserInfo와 userInfo 모두 업데이트
    // 댓글창 초기화를 통해 댓글 프로필에도 업데이트 반영
    ref.read(userInfoProvider.notifier).updateUserInfo(respProfile);
    ref.invalidate(shortFormCommentHeightControllerProvider);
    state = respProfile;
    return ProviderResponseModel(
      success: true,
      errorCode: null,
      errorMessage: null,
    );
  }

  /// 현재 상태가 유효한지 확인 후, 유효한 경우 prevState 반환
  DetailUserModel? _getValidPrevState() =>
      // 이전 상태가 DetailUserModel(정상적으로 데이터가 불러와진 상태)이고 유저 정보가 UserModel(로그인 상태)이면 이전 상태 반환
      state is DetailUserModel && ref.read(userInfoProvider) is UserModel
          ? state as DetailUserModel
          : null;
}
