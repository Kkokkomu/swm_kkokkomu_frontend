// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_pagination_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPaginationParams _$CursorPaginationParamsFromJson(
        Map<String, dynamic> json) =>
    CursorPaginationParams(
      cursorId: (json['cursorId'] as num?)?.toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$CursorPaginationParamsToJson(
    CursorPaginationParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cursorId', instance.cursorId);
  val['size'] = instance.size;
  return val;
}
