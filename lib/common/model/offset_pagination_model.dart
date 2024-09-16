// import 'package:json_annotation/json_annotation.dart';

// part 'offset_pagination_model.g.dart';

// abstract class OffsetPaginationBase {}

// class OffsetPaginationError extends OffsetPaginationBase {
//   final String message;

//   OffsetPaginationError({
//     required this.message,
//   });
// }

// class OffsetPaginationLoading extends OffsetPaginationBase {}

// @JsonSerializable(
//   genericArgumentFactories: true,
// )
// class OffsetPagination<T> extends OffsetPaginationBase {
//   final OffsetPaginationMeta pageInfo;
//   final List<T> items;

//   OffsetPagination({
//     required this.pageInfo,
//     required this.items,
//   });

//   OffsetPagination copyWith({
//     OffsetPaginationMeta? pageInfo,
//     List<T>? items,
//   }) {
//     return OffsetPagination<T>(
//       pageInfo: pageInfo ?? this.pageInfo,
//       items: items ?? this.items,
//     );
//   }

//   factory OffsetPagination.fromJson(
//           Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
//       _$OffsetPaginationFromJson(json, fromJsonT);
// }

// @JsonSerializable()
// class OffsetPaginationMeta {
//   final int page;
//   final int size;
//   final int totalPages;
//   final bool isLast;

//   OffsetPaginationMeta({
//     required this.page,
//     required this.size,
//     required this.totalPages,
//     required this.isLast,
//   });

//   OffsetPaginationMeta copyWith({
//     int? page,
//     int? size,
//     int? totalPages,
//     bool? isLast,
//   }) {
//     return OffsetPaginationMeta(
//       page: page ?? this.page,
//       size: size ?? this.size,
//       totalPages: totalPages ?? this.totalPages,
//       isLast: isLast ?? this.isLast,
//     );
//   }

//   factory OffsetPaginationMeta.fromJson(Map<String, dynamic> json) =>
//       _$OffsetPaginationMetaFromJson(json);
// }

// // 새로고침 할때
// class OffsetPaginationRefetching<T> extends OffsetPagination<T> {
//   OffsetPaginationRefetching({
//     required super.pageInfo,
//     required super.items,
//   });
// }

// // 리스트의 맨 아래로 내려서
// // 추가 데이터를 요청하는중
// class OffsetPaginationFetchingMore<T> extends OffsetPagination<T> {
//   OffsetPaginationFetchingMore({
//     required super.pageInfo,
//     required super.items,
//   });
// }

// // 리스트의 맨 아래로 내려서
// // 추가 데이터를 요청하는중 발생한 에러
// class OffsetPaginationFetchingMoreError<T> extends OffsetPagination<T> {
//   final String message;

//   OffsetPaginationFetchingMoreError({
//     required super.pageInfo,
//     required super.items,
//     required this.message,
//   });
// }
