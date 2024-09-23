class ProviderResponseModel {
  final bool success;
  final String? errorCode;
  final String? errorMessage;

  ProviderResponseModel({
    required this.success,
    required this.errorCode,
    required this.errorMessage,
  });
}
