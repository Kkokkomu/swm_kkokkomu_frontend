import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';

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
  exploration(CustomRoutePath.exploration),
  home(CustomRoutePath.home),
  myPage(CustomRoutePath.myPage);

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

@JsonEnum(valueField: 'name')
enum CommentReportType {
  offensive('OFFENSIVE', '불쾌감을 주거나 부적절한 이름'),
  profane('PROFANE', '욕설'),
  violent('VIOLENT', '폭력적 또는 혐오스러운 콘텐츠'),
  porno('PORNO', '성적인 콘텐츠'),
  spam('SPAM', '스팸 또는 혼동을 야기하는 콘텐츠');

  final String name;
  final String message;

  const CommentReportType(this.name, this.message);
}

@JsonEnum(valueField: 'name')
enum ShortFormReportType {
  misinformation('MISINFORMATION', '잘못된 정보'),
  violent('VIOLENT', '폭력적 또는 혐오스러운 콘텐츠'),
  porno('PORNO', '성적인 콘텐츠'),
  legal('legal', '법적 문제'),
  spam('SPAM', '스팸 또는 혼동을 야기하는 콘텐츠');

  final String name;
  final String message;

  const ShortFormReportType(this.name, this.message);
}

// loadingStateProvider 에서 사용하는 요청 종류
// enum RequestType {
//   postComment,
// }
