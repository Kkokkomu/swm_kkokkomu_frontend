import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

final explorationCategoryProvider =
    StateProvider.autoDispose<NewsCategoryInExploration>((ref) {
  return NewsCategoryInExploration.popular;
});
