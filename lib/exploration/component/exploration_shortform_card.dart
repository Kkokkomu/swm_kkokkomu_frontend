import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/const/custom_text_style.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExplorationShortFormCard extends StatelessWidget {
  final ShortFormNewsInfo newsInfo;

  const ExplorationShortFormCard({
    super.key,
    required this.newsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: newsInfo.thumbnail ?? '',
                // 가로 높이보다 세로 높이가 큰 숏폼 섬네일이므로
                // 가로 너비를 기준으로 섬네일을 불러온다
                memCacheWidth: (constraints.maxWidth *
                        MediaQuery.of(context).devicePixelRatio)
                    .round(),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                placeholder: (_, __) => Skeletonizer(
                  effect: const SoldColorEffect(
                    color: ColorName.gray100,
                  ),
                  child: Container(
                    color: Colors.black,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: ColorName.gray100,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsInfo.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.body3Bold(
                          color: ColorName.white000,
                          shadows: [
                            const Shadow(
                              color: Colors.black,
                              blurRadius: 16.0,
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.icons.svg.icView.svg(),
                              const SizedBox(width: 4.0),
                              Flexible(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  '${NumberFormat.compact(locale: 'ko_KR').format(newsInfo.viewCnt)} · ',
                                  style: CustomTextStyle.detail3Reg(
                                    color: ColorName.gray50,
                                    shadows: [
                                      const Shadow(
                                        color: Colors.black,
                                        blurRadius: 16.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            timeago.format(newsInfo.createdAt, locale: 'ko'),
                            style: CustomTextStyle.detail3Reg(
                              color: ColorName.gray50,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  blurRadius: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
