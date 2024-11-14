import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_route_path.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

part 'enums.g.dart';

enum SocialLoginType { apple, google, kakao }

@JsonEnum(alwaysCreate: true, valueField: 'name')
enum GenderType {
  man('MAN', '남성'),
  woman('WOMAN', '여성'),
  none('NONE', '선택안함');

  final String name;
  final String label;

  const GenderType(this.name, this.label);

  static final _genderTypeLabelMap =
      _$GenderTypeEnumMap.map((key, value) => MapEntry(key.label, key));

  static GenderType? fromLabel(String name) => _genderTypeLabelMap[name];
}

@JsonEnum(alwaysCreate: true, valueField: 'name')
enum ShortFormSortType {
  recommend('RECOMMEND', '인기순'),
  latest('LATEST', '최신순');

  final String name;
  final String label;

  const ShortFormSortType(this.name, this.label);

  static final _shortFormSortTypeNameMap =
      _$ShortFormSortTypeEnumMap.map((key, value) => MapEntry(value, key));

  static ShortFormSortType? fromName(String name) =>
      _shortFormSortTypeNameMap[name];
}

enum ShortFormCommentSortType { popular, latest }

@JsonEnum(valueField: 'name')
enum NewsCategory {
  politics('POLITICS', '정치'),
  economy('ECONOMY', '경제'),
  social('SOCIAL', '사회'),
  entertain('ENTERTAIN', '연예'),
  sports('SPORTS', '스포츠'),
  living('LIVING', '생활'),
  world('WORLD', '세계'),
  it('IT', 'IT');

  final String name;
  final String label;

  const NewsCategory(this.name, this.label);

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

@JsonEnum(alwaysCreate: true)
enum NewsCategoryInExploration {
  popular('인기 급상승'),
  politics('정치'),
  economy('경제'),
  social('사회'),
  entertain('연예'),
  sports('스포츠'),
  living('생활'),
  world('세계'),
  it('IT');

  final String label;

  const NewsCategoryInExploration(this.label);

  static final _newsCategoryInExplorationNameMap =
      _$NewsCategoryInExplorationEnumMap
          .map((key, value) => MapEntry(value, key));

  static NewsCategoryInExploration? fromName(String name) =>
      _newsCategoryInExplorationNameMap[name];

  String get blueChipSvgPath => switch (this) {
        NewsCategoryInExploration.popular => Assets.icons.svg.chipPopular.path,
        NewsCategoryInExploration.politics =>
          Assets.icons.svg.chipPolitics.path,
        NewsCategoryInExploration.economy => Assets.icons.svg.chipEconomy.path,
        NewsCategoryInExploration.social => Assets.icons.svg.chipSociety.path,
        NewsCategoryInExploration.entertain =>
          Assets.icons.svg.chipEntertain.path,
        NewsCategoryInExploration.sports => Assets.icons.svg.chipSports.path,
        NewsCategoryInExploration.living => Assets.icons.svg.chipLife.path,
        NewsCategoryInExploration.world => Assets.icons.svg.chipWorld.path,
        NewsCategoryInExploration.it => Assets.icons.svg.chipIt.path,
      };

  String get graySvgPath => switch (this) {
        NewsCategoryInExploration.popular =>
          Assets.icons.svg.icPopularMini.path,
        NewsCategoryInExploration.politics =>
          Assets.icons.svg.icPoliticsGray.path,
        NewsCategoryInExploration.economy =>
          Assets.icons.svg.icEconomyGray.path,
        NewsCategoryInExploration.social => Assets.icons.svg.icSocietyGray.path,
        NewsCategoryInExploration.entertain =>
          Assets.icons.svg.icEntertainGray.path,
        NewsCategoryInExploration.sports => Assets.icons.svg.icSportsGray.path,
        NewsCategoryInExploration.living => Assets.icons.svg.icLifeGray.path,
        NewsCategoryInExploration.world => Assets.icons.svg.icWorldGray.path,
        NewsCategoryInExploration.it => Assets.icons.svg.icItGray.path,
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
  violent('VIOLENT', '폭력적 또는 혐오적인 댓글'),
  porno('PORNO', '성적인 댓글'),
  spam('SPAM', '스팸 또는 혼동을 야기하는 댓글');

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
  like('LIKE', '좋아요'),
  angry('ANGRY', '화나요'),
  surprise('SURPRISE', '놀라워요'),
  sad('SAD', '슬퍼요');

  final String name;
  final String label;

  const ReactionType(this.name, this.label);

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

enum ShortFormScreenType {
  home(CustomRoutePath.home),
  exploration(CustomRoutePath.explorationShortForm),
  shortFormSearched(CustomRoutePath.shortFormSearched),
  myViewLog(CustomRoutePath.myViewLogShortForm),
  myReactionLog(CustomRoutePath.myReactionLogShortForm),
  myCommentLog(CustomRoutePath.myCommentLogShortForm);

  final String path;

  const ShortFormScreenType(this.path);
}

@JsonEnum(alwaysCreate: true, valueField: 'channelId')
enum PushNotificationChannelType {
  // 공지사항 알림 채널
  notice('notice', '공지사항'),
  // 대댓글 알림 채널
  reply('reply', '대댓글'),
  // 새 뉴스 알림 채널
  newArticle('new_article', '새 뉴스'),
  // 디폴트 알림 채널
  general('general', '일반');

  final String channelId;
  final String channelName;

  const PushNotificationChannelType(this.channelId, this.channelName);

  static final _pushNotificationChannelTypeIdMap =
      _$PushNotificationChannelTypeEnumMap
          .map((key, value) => MapEntry(value, key));

  static PushNotificationChannelType fromId(String channelId) =>
      _pushNotificationChannelTypeIdMap[channelId] ?? general;
}

enum NotificationSettingType {
  notice('공지사항 알림'),
  newArticle('새 뉴스 알림'),
  reply('대댓글 알림'),
  nightNotification('야간 알림 허용');

  final String label;

  const NotificationSettingType(this.label);
}

@JsonEnum(alwaysCreate: true, valueField: 'name')
enum NotificationLogType {
  notice('NOTICE'),
  reply('REPLY'),
  newsArticle('NEWS_ARTICLE'),
  test('TEST');

  final String name;

  const NotificationLogType(this.name);

  static final _notificationLogTypeNameMap =
      _$NotificationLogTypeEnumMap.map((key, value) => MapEntry(value, key));

  static NotificationLogType? fromName(String name) =>
      _notificationLogTypeNameMap[name];
}

// TODO : 딥링크 타입 구현해야 함 ex) 공지, 대댓글, 새 뉴스 등등
enum DeepLinkType {
  notice,
}

// loadingStateProvider 에서 사용하는 요청 종류
// enum RequestType {
//   postComment,
// }
