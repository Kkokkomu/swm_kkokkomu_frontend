import 'package:json_annotation/json_annotation.dart';

part 'user_shortform_category_filter_model.g.dart';

@JsonSerializable()
class UserShortFormCategoryFilterModel {
  @JsonKey(includeToJson: false)
  final int? userId;
  final bool politics;
  final bool economy;
  final bool social;
  final bool entertain;
  final bool sports;
  final bool living;
  final bool world;
  final bool it;

  UserShortFormCategoryFilterModel({
    this.userId,
    bool? politics,
    bool? economy,
    bool? social,
    bool? entertain,
    bool? sports,
    bool? living,
    bool? world,
    bool? it,
  })  : politics = politics ?? true,
        economy = economy ?? true,
        social = social ?? true,
        entertain = entertain ?? true,
        sports = sports ?? true,
        living = living ?? true,
        world = world ?? true,
        it = it ?? true;

  factory UserShortFormCategoryFilterModel.fromJson(
          Map<String, dynamic> json) =>
      _$UserShortFormCategoryFilterModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserShortFormCategoryFilterModelToJson(this);

  UserShortFormCategoryFilterModel copyWith({
    bool? politics,
    bool? economy,
    bool? social,
    bool? entertain,
    bool? sports,
    bool? living,
    bool? world,
    bool? it,
  }) {
    return UserShortFormCategoryFilterModel(
      userId: userId,
      politics: politics ?? this.politics,
      economy: economy ?? this.economy,
      social: social ?? this.social,
      entertain: entertain ?? this.entertain,
      sports: sports ?? this.sports,
      living: living ?? this.living,
      world: world ?? this.world,
      it: it ?? this.it,
    );
  }
}
