import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

final shortFormCommentSortTypeProvider =
    StateProvider.family.autoDispose<ShortFormCommentSortType, int>(
  (ref, newsId) => ShortFormCommentSortType.popular,
);
