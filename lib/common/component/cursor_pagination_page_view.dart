// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:swm_kkokkomu_frontend/common/component/custom_circular_progress_indicator.dart';
// import 'package:swm_kkokkomu_frontend/common/component/custom_refresh_indicator.dart';
// import 'package:swm_kkokkomu_frontend/common/const/data.dart';
// import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
// import 'package:swm_kkokkomu_frontend/common/model/cursor_pagination_model.dart';
// import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';
// import 'package:swm_kkokkomu_frontend/common/provider/cursor_pagination_provider.dart';
// import 'package:swm_kkokkomu_frontend/common/repository/base_cursor_pagination_repository.dart';

// class CursorPaginationPageView<T extends IModelWithId> extends ConsumerWidget {
//   final AutoDisposeStateNotifierProvider<
//       CursorPaginationProvider<T, IBaseCursorPaginationRepository<T>>,
//       CursorPaginationBase> provider;
//   final PaginationWidgetBuilder<T> itemBuilder;
//   final ScrollPhysics? scrollPhysics;
//   final int initialPageIndex;

//   const CursorPaginationPageView({
//     super.key,
//     required this.provider,
//     required this.itemBuilder,
//     this.scrollPhysics,
//     this.initialPageIndex = 0,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(provider);

//     // 완전 처음 로딩일때
//     if (state is CursorPaginationLoading) {
//       return const Center(
//         child: CustomCircularProgressIndicator(),
//       );
//     }

//     // 에러
//     if (state is CursorPaginationError) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             state.message,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: () =>
//                 ref.read(provider.notifier).paginate(forceRefetch: true),
//             child: const Text(
//               '다시시도',
//             ),
//           ),
//         ],
//       );
//     }

//     // CursorPagination
//     // CursorPaginationFetchingMore
//     // CursorPaginationRefetching

//     final paginationData = state as CursorPagination<T>;

//     return CustomRefreshIndicator(
//       onRefresh: () => ref.read(provider.notifier).paginate(forceRefetch: true),
//       child: PageView.builder(
//         controller: PageController(initialPage: initialPageIndex),
//         allowImplicitScrolling: true,
//         physics: scrollPhysics,
//         scrollDirection: Axis.vertical,
//         itemCount: paginationData.items.length + 1,
//         onPageChanged: (value) {
//           if (state is! CursorPaginationFetchingMoreError &&
//               value ==
//                   paginationData.items.length -
//                       1 -
//                       (Constants.cursorPaginationFetchCount * 0.2).toInt()) {
//             ref.read(provider.notifier).paginate(fetchMore: true);
//           }
//         },
//         itemBuilder: (context, index) {
//           if (index == paginationData.items.length) {
//             if (paginationData is CursorPaginationFetchingMore) {
//               return const Center(
//                 child: CustomCircularProgressIndicator(),
//               );
//             }

//             if (paginationData is CursorPaginationFetchingMoreError) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     (paginationData as CursorPaginationFetchingMoreError)
//                         .message,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                   const SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () =>
//                         ref.read(provider.notifier).paginate(fetchMore: true),
//                     child: const Text(
//                       '다시시도',
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: () => ref
//                         .read(provider.notifier)
//                         .paginate(forceRefetch: true),
//                     child: const Text(
//                       '전체 새로고침',
//                     ),
//                   ),
//                 ],
//               );
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   '더 가져올 데이터가 없습니다.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: ColorName.white000,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16.0,
//                 ),
//                 ElevatedButton(
//                   onPressed: () =>
//                       ref.read(provider.notifier).paginate(forceRefetch: true),
//                   child: const Text('새로고침'),
//                 ),
//               ],
//             );
//           }

//           final paginationItem = paginationData.items[index];

//           return itemBuilder(
//             context,
//             index,
//             paginationItem,
//           );
//         },
//       ),
//     );
//   }
// }
