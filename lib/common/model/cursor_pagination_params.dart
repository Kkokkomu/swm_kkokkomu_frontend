import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_params.g.dart';

@JsonSerializable(includeIfNull: false)
class CursorPaginationParams {
  final int? cursorId;
  final int size;

  const CursorPaginationParams({
    this.cursorId,
    required this.size,
  });

  CursorPaginationParams copyWith({
    int? cursorId,
    int? size,
  }) {
    return CursorPaginationParams(
      cursorId: cursorId ?? this.cursorId,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toJson() => _$CursorPaginationParamsToJson(this);
}
