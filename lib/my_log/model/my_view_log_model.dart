import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_model_with_id_and_url.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/pagination_shortform_model.dart';

part 'my_view_log_model.g.dart';

@JsonSerializable()
class MyViewLogModel implements IShortFormModelWithIdAndNewsIdAndUrl {
  @override
  final int id;
  @override
  final int newsId;
  @override
  final String? shortFormUrl;
  final PaginationShortFormModel news;

  MyViewLogModel({
    int? id,
    PaginationShortFormModel? news,
  })  : id = id ?? Constants.unknownErrorId,
        news = news ?? PaginationShortFormModel(),
        newsId = news?.info.news.id ?? Constants.unknownErrorId,
        shortFormUrl = news?.info.news.shortformUrl;

  factory MyViewLogModel.fromJson(Map<String, dynamic> json) =>
      _$MyViewLogModelFromJson(json);
}
