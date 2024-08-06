class DataUtils {
  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요.';
    }

    // 숫자, 한글, 영어만 허용하는 정규 표현식
    final regex = RegExp(r'^[0-9가-힣a-zA-Z]+$');
    if (!regex.hasMatch(value)) {
      return '숫자, 완성형 한글, 영어만 입력 가능합니다';
    }

    // 길이 검사를 추가
    if (value.length < 2 || value.length > 10) {
      return '닉네임은 2자 이상 10자 이하로 입력해주세요.';
    }

    return null;
  }
}
