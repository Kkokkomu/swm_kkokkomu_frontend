import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'shortform_detail_info_model.g.dart';

sealed class ShortFormDetailInfoModelBase {}

class ShortFormDetailInfoModelLoading extends ShortFormDetailInfoModelBase {}

class ShortFormDetailInfoModelError extends ShortFormDetailInfoModelBase {
  final String message;

  ShortFormDetailInfoModelError(this.message);
}

@JsonSerializable()
class ShortFormDetailInfoModel extends ShortFormDetailInfoModelBase {
  final ShortFormDetailNewsInfo news;
  final List<String> keywords;

  ShortFormDetailInfoModel({
    ShortFormDetailNewsInfo? news,
    List<String>? keywords,
  })  : news = news ?? ShortFormDetailNewsInfo(),
        keywords = keywords ?? [];

  factory ShortFormDetailInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ShortFormDetailInfoModelFromJson(json);
}

@JsonSerializable()
class ShortFormDetailNewsInfo {
  final int id;
  final String? shortformUrl;
  final String? youtubeUrl;
  final String? instagramUrl;
  final String? relatedUrl;
  final String? thumbnail;
  final int viewCnt;
  final String title;
  final String summary;
  final int sharedCnt;
  final NewsCategory? category;
  final String createdAt;
  final String editedAt;

  ShortFormDetailNewsInfo({
    int? id,
    this.shortformUrl,
    this.youtubeUrl,
    this.instagramUrl,
    this.relatedUrl,
    this.thumbnail,
    int? viewCnt,
    String? title,
    String? summary,
    int? sharedCnt,
    this.category,
    String? createdAt,
    String? editedAt,
  })  : id = id ?? Constants.unknownErrorId,
        viewCnt = viewCnt ?? 0,
        title = title ?? Constants.unknownErrorString,
        summary = summary ?? Constants.unknownErrorString,
        sharedCnt = sharedCnt ?? 0,
        createdAt = createdAt ?? Constants.unknownErrorString,
        editedAt = editedAt ?? Constants.unknownErrorString;

  factory ShortFormDetailNewsInfo.fromJson(Map<String, dynamic> json) =>
      _$ShortFormDetailNewsInfoFromJson(json);
}
