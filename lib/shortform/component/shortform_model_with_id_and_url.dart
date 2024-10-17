import 'package:swm_kkokkomu_frontend/common/model/model_with_id.dart';

abstract class IShortFormModelWithIdAndNewsIdAndUrl extends IModelWithId {
  final int newsId;
  final String? shortFormUrl;

  IShortFormModelWithIdAndNewsIdAndUrl({
    required super.id,
    required this.newsId,
    required this.shortFormUrl,
  });
}
