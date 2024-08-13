import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta pageInfo;
  final List<T> items;

  CursorPagination({
    required this.pageInfo,
    required this.items,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? pageInfo,
    List<T>? items,
  }) {
    return CursorPagination<T>(
      pageInfo: pageInfo ?? this.pageInfo,
      items: items ?? this.items,
    );
  }

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int size;
  final bool isLast;

  CursorPaginationMeta({
    required this.size,
    required this.isLast,
  });

  CursorPaginationMeta copyWith({
    int? size,
    bool? isLast,
  }) {
    return CursorPaginationMeta(
      size: size ?? this.size,
      isLast: isLast ?? this.isLast,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 새로고침 할때
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.pageInfo,
    required super.items,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는중
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.pageInfo,
    required super.items,
  });
}

// 리스트의 맨 아래로 내려서
// 추가 데이터를 요청하는중 발생한 에러
class CursorPaginationFetchingMoreError<T> extends CursorPagination<T> {
  final String message;

  CursorPaginationFetchingMoreError({
    required super.pageInfo,
    required super.items,
    required this.message,
  });
}
