import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

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

enum ShortFormCommentSortType { popular, latest }

enum NewsCategory {
  politics('정치'),
  economy('경제'),
  social('사회'),
  entertain('연예'),
  sports('스포츠'),
  living('생활'),
  world('세계'),
  it('IT');

  final String label;

  const NewsCategory(this.label);

  String get graySvgPath => switch (this) {
        NewsCategory.politics => Assets.icons.svg.icPoliticsGray.path,
        NewsCategory.economy => Assets.icons.svg.icEconomyGray.path,
        NewsCategory.social => Assets.icons.svg.icSocietyGray.path,
        NewsCategory.entertain => Assets.icons.svg.icEntertainGray.path,
        NewsCategory.sports => Assets.icons.svg.icSportsGray.path,
        NewsCategory.living => Assets.icons.svg.icLifeGray.path,
        NewsCategory.world => Assets.icons.svg.icWorldGray.path,
        NewsCategory.it => Assets.icons.svg.icItGray.path,
      };

  String get blueSvgPath => switch (this) {
        NewsCategory.politics => Assets.icons.svg.icPoliticsBlue.path,
        NewsCategory.economy => Assets.icons.svg.icEconomyBlue.path,
        NewsCategory.social => Assets.icons.svg.icSocietyBlue.path,
        NewsCategory.entertain => Assets.icons.svg.icEntertainBlue.path,
        NewsCategory.sports => Assets.icons.svg.icSportsBlue.path,
        NewsCategory.living => Assets.icons.svg.icLifeBlue.path,
        NewsCategory.world => Assets.icons.svg.icWorldBlue.path,
        NewsCategory.it => Assets.icons.svg.icItBlue.path,
      };
}

enum RootTabBottomNavigationBarType {
  exploration(CustomRoutePath.exploration),
  home(CustomRoutePath.home),
  myPage(CustomRoutePath.myPage);

  final String path;

  const RootTabBottomNavigationBarType(this.path);
}

enum ShortFormMoreInfoPopupType {
  viewDescription,
  nonInterested,
  report,
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
  replyPost,
  replyUpdate,
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
  legal('LEGAL', '법적 문제'),
  spam('SPAM', '스팸 또는 혼동을 야기하는 콘텐츠');

  final String name;
  final String message;

  const ShortFormReportType(this.name, this.message);
}

@JsonEnum(valueField: 'name')
enum ReactionType {
  like('LIKE'),
  angry('ANGRY'),
  surprise('SURPRISE'),
  sad('SAD');

  final String name;

  const ReactionType(this.name);

  String get whiteSvgPath => switch (this) {
        ReactionType.like => Assets.icons.svg.icGoodWhite.path,
        ReactionType.angry => Assets.icons.svg.icAngryWhite.path,
        ReactionType.surprise => Assets.icons.svg.icSurpriseWhite.path,
        ReactionType.sad => Assets.icons.svg.icSadWhite.path,
      };

  String get graySvgPath => switch (this) {
        ReactionType.like => Assets.icons.svg.icGoodGray.path,
        ReactionType.angry => Assets.icons.svg.icAngryGray.path,
        ReactionType.surprise => Assets.icons.svg.icSurpriseGray.path,
        ReactionType.sad => Assets.icons.svg.icSadGray.path,
      };

  String get blueSvgPath => switch (this) {
        ReactionType.like => Assets.icons.svg.icGoodBlue.path,
        ReactionType.angry => Assets.icons.svg.icAngryBlue.path,
        ReactionType.surprise => Assets.icons.svg.icSurpriseBlue.path,
        ReactionType.sad => Assets.icons.svg.icSadBlue.path,
      };
}

// loadingStateProvider 에서 사용하는 요청 종류
// enum RequestType {
//   postComment,
// }
