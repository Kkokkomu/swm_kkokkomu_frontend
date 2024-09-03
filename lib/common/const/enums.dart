import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';

part 'enums.g.dart';

enum SocialLoginType { apple, kakao }

@JsonEnum(valueField: 'name')
enum GenderType {
  man('MAN'),
  woman('WOMAN'),
  none('NONE');

  final String name;

  const GenderType(this.name);
}

@JsonEnum(alwaysCreate: true, valueField: 'name')
enum ShortFormSortType {
  recommend('RECOMMEND'),
  latest('LATEST');

  final String name;

  const ShortFormSortType(this.name);

  static final _shortFormSortTypeNameMap =
      _$ShortFormSortTypeEnumMap.map((key, value) => MapEntry(value, key));

  static ShortFormSortType? fromName(String name) =>
      _shortFormSortTypeNameMap[name];
}

enum NewsCategory {
  politics,
  economy,
  social,
  entertain,
  sports,
  living,
  world,
  it
}

enum ShortFormCommentSortType { popular, latest }

enum RootTabBottomNavigationBarType {
  exploration(RoutePath.exploration),
  shortForm(RoutePath.shortForm),
  myPage(RoutePath.myPage);

  final String path;

  const RootTabBottomNavigationBarType(this.path);
}

enum ShortFormCommentPopupType {
  update,
  delete,
  block,
  report,
}

enum ShortFormCommentSendButtonType {
  post,
  update,
}

// loadingStateProvider 에서 사용하는 요청 종류
// enum RequestType {
//   postComment,
// }