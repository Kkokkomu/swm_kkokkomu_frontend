class CustomErrorCode {
  // 서버로 부터 response error code 를 받지 못한 경우
  static const String unknownCode = '99999';

  // 이미 신고한 숏폼을 다시 신고하는 경우
  static const String alreadyReportedShortFormCode = '40032';

  // 이미 신고한 댓글을 다시 신고하는 경우
  static const String alreadyReportedCommentCode = '40028';

  // 댓글 작성이 정지된 유저인 경우
  static const String commentBannedCode = '40029';

  // 이미 해당 이메일로 가입된 계정이 있는 경우
  static const String emailAlreadyExistsCode = '40015';

  // 닉네임이 중복된 경우
  static const String nicknameAlreadyExistsCode = '40007';
}
