class NickNameValidationModel {
  final bool isMoreOrEqualThanTwoCharacters;
  final bool isLessOrEqualThanTenCharacters;
  final bool isAlphaOrNumericOrKorean;
  final String? errorMessage;
  final bool isValid;

  NickNameValidationModel({
    required this.isMoreOrEqualThanTwoCharacters,
    required this.isLessOrEqualThanTenCharacters,
    required this.isAlphaOrNumericOrKorean,
    this.errorMessage,
  }) : isValid = isMoreOrEqualThanTwoCharacters &&
            isLessOrEqualThanTenCharacters &&
            isAlphaOrNumericOrKorean &&
            errorMessage == null;

  NickNameValidationModel copyWith({
    bool? isMoreOrEqualThanTwoCharacters,
    bool? isLessOrEqualThanTenCharacters,
    bool? isAlphaOrNumericOrKorean,
    String? errorMessage,
  }) {
    return NickNameValidationModel(
      isMoreOrEqualThanTwoCharacters:
          isMoreOrEqualThanTwoCharacters ?? this.isMoreOrEqualThanTwoCharacters,
      isLessOrEqualThanTenCharacters:
          isLessOrEqualThanTenCharacters ?? this.isLessOrEqualThanTenCharacters,
      isAlphaOrNumericOrKorean:
          isAlphaOrNumericOrKorean ?? this.isAlphaOrNumericOrKorean,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(covariant NickNameValidationModel other) {
    if (identical(this, other)) return true;

    return other.isMoreOrEqualThanTwoCharacters ==
            isMoreOrEqualThanTwoCharacters &&
        other.isLessOrEqualThanTenCharacters ==
            isLessOrEqualThanTenCharacters &&
        other.isAlphaOrNumericOrKorean == isAlphaOrNumericOrKorean &&
        other.errorMessage == errorMessage &&
        other.isValid == isValid;
  }

  @override
  int get hashCode {
    return isMoreOrEqualThanTwoCharacters.hashCode ^
        isLessOrEqualThanTenCharacters.hashCode ^
        isAlphaOrNumericOrKorean.hashCode ^
        errorMessage.hashCode ^
        isValid.hashCode;
  }
}
