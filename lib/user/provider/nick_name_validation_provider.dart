import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/user/model/nick_name_validation_model.dart';

final nickNameValidationProvider = StateNotifierProvider.family
    .autoDispose<NickNameValidationStateNotifier, NickNameValidationModel, Key>(
  (ref, key) => NickNameValidationStateNotifier(),
);

class NickNameValidationStateNotifier
    extends StateNotifier<NickNameValidationModel> {
  final Set<String> _alreadyExistNickName = <String>{};

  NickNameValidationStateNotifier()
      : super(
          NickNameValidationModel(
            isMoreOrEqualThanTwoCharacters: false,
            isLessOrEqualThanTenCharacters: false,
            isAlphaOrNumericOrKorean: false,
          ),
        );

  void setValidation(String? nickName) {
    // 초기 상태
    NickNameValidationModel nextState = NickNameValidationModel(
      isMoreOrEqualThanTwoCharacters: true,
      isLessOrEqualThanTenCharacters: true,
      isAlphaOrNumericOrKorean: true,
    );

    // 닉네임이 비어있는 경우 모두 false로 설정 후 리턴
    if (nickName == null || nickName.isEmpty) {
      state = nextState.copyWith(
        isMoreOrEqualThanTwoCharacters: false,
        isLessOrEqualThanTenCharacters: false,
        isAlphaOrNumericOrKorean: false,
      );
      return;
    }

    // 길이 검사
    if (nickName.length < 2) {
      nextState = nextState.copyWith(
        isMoreOrEqualThanTwoCharacters: false,
      );
    }

    if (nickName.length > 10) {
      nextState = nextState.copyWith(
        isLessOrEqualThanTenCharacters: false,
      );
    }

    // 숫자, 한글, 영어만 허용하는 정규 표현식
    final regex = RegExp(r'^[0-9가-힣a-zA-Z]+$');
    if (!regex.hasMatch(nickName)) {
      nextState = nextState.copyWith(
        isAlphaOrNumericOrKorean: false,
      );
    }

    if (_alreadyExistNickName.contains(nickName)) {
      nextState = nextState.copyWith(errorMessage: '이미 존재하는 닉네임이에요');
    }

    // 최종 상태 설정
    state = nextState;
  }

  bool validateNickName(String? nickName) {
    if (nickName == null || nickName.isEmpty) {
      return false;
    }

    // 길이 검사
    if (nickName.length < 2) {
      return false;
    }

    if (nickName.length > 10) {
      return false;
    }

    // 숫자, 한글, 영어만 허용하는 정규 표현식
    final regex = RegExp(r'^[0-9가-힣a-zA-Z]+$');
    if (!regex.hasMatch(nickName)) {
      return false;
    }

    return true;
  }

  void setAlreadyExistNickName(String nickname) {
    _alreadyExistNickName.add(nickname);
    state = state.copyWith(errorMessage: '이미 존재하는 닉네임이에요');
  }
}
