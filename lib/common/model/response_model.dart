import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class ResponseModel<T> {
  final bool? success;
  final T? data;
  final ResponseErrorModel? error;

  ResponseModel({
    required this.success,
    required this.data,
    required this.error,
  }) {
    if (success != true) {
      print('Response 에러 발생');
      print('ErrorCode: ${error?.code}');
      print('ErrorMessage: ${error?.message}');
    }
  }

  factory ResponseModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ResponseModelFromJson(json, fromJsonT);
}

@JsonSerializable()
class ResponseErrorModel {
  final int? code;
  final String? message;

  ResponseErrorModel({
    required this.code,
    required this.message,
  });

  factory ResponseErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseErrorModelFromJson(json);
}
