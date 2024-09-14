import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:swm_kkokkomu_frontend/common/gen/colors.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

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
        borderRadius: BorderRadius.circular(16.0),
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsInfo.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorName.white000,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 16.0,
                          ),
                        ],
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 16,
                              color: ColorName.white000,
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 4.0)),
                          TextSpan(
                            text: '${newsInfo.viewCnt} · ${newsInfo.createdAt}',
                            style: const TextStyle(
                              color: ColorName.white000,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 16.0,
                                ),
                              ],
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
