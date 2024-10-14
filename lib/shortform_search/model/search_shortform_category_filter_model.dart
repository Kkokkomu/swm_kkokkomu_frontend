import 'package:json_annotation/json_annotation.dart';
import 'package:swm_kkokkomu_frontend/common/const/enums.dart';

part 'search_shortform_category_filter_model.g.dart';

@JsonSerializable()
class SearchShortFormCategoryFilterModel {
  final bool politics;
  final bool economy;
  final bool social;
  final bool entertain;
  final bool sports;
  final bool living;
  final bool world;
  final bool it;

  SearchShortFormCategoryFilterModel({
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

  Map<String, dynamic> toJson() =>
      _$SearchShortFormCategoryFilterModelToJson(this);

  String categoriesToString() {
    final categories = <String>[];

    if (politics) {
      categories.add(NewsCategory.politics.name.toLowerCase());
    }
    if (economy) {
      categories.add(NewsCategory.economy.name.toLowerCase());
    }
    if (social) {
      categories.add(NewsCategory.social.name.toLowerCase());
    }
    if (entertain) {
      categories.add(NewsCategory.entertain.name.toLowerCase());
    }
    if (sports) {
      categories.add(NewsCategory.sports.name.toLowerCase());
    }
    if (living) {
      categories.add(NewsCategory.living.name.toLowerCase());
    }
    if (world) {
      categories.add(NewsCategory.world.name.toLowerCase());
    }
    if (it) {
      categories.add(NewsCategory.it.name.toLowerCase());
    }

    return categories.join(',');
  }

  String getCategoryFilterLabel() {
    if (isAllCategorySelected() || isAllCategoryUnSelected()) {
      return '카테고리';
    }

    final selectedCategories = [
      if (politics) '정치',
      if (economy) '경제',
      if (social) '사회',
      if (entertain) '연예',
      if (sports) '스포츠',
      if (living) '생활',
      if (world) '세계',
      if (it) 'IT',
    ];

    if (selectedCategories.length <= 2) {
      return selectedCategories.join(', ');
    } else {
      return '${selectedCategories.take(2).join(', ')} 외 ${selectedCategories.length - 2}';
    }
  }

  bool isCategorySelected(NewsCategory category) => switch (category) {
        NewsCategory.politics => politics,
        NewsCategory.economy => economy,
        NewsCategory.social => social,
        NewsCategory.entertain => entertain,
        NewsCategory.sports => sports,
        NewsCategory.living => living,
        NewsCategory.world => world,
        NewsCategory.it => it
      };

  bool isAllCategorySelected() =>
      politics &&
      economy &&
      social &&
      entertain &&
      sports &&
      living &&
      world &&
      it;

  bool isAllCategoryUnSelected() =>
      !politics &&
      !economy &&
      !social &&
      !entertain &&
      !sports &&
      !living &&
      !world &&
      !it;

  SearchShortFormCategoryFilterModel copyWith({
    bool? politics,
    bool? economy,
    bool? social,
    bool? entertain,
    bool? sports,
    bool? living,
    bool? world,
    bool? it,
  }) {
    return SearchShortFormCategoryFilterModel(
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
