import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';

class MyPageEventBanner extends StatelessWidget {
  const MyPageEventBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Center(
        child: GestureDetector(
          onTap: () => InAppReview.instance
              .openStoreListing(appStoreId: Constants.iosAppStoreId),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Assets.images.png.imgReviewBanner.image(
              width: MediaQuery.sizeOf(context).width - 36.0,
              cacheWidth: ((MediaQuery.sizeOf(context).width - 36.0) *
                      MediaQuery.of(context).devicePixelRatio)
                  .round(),
            ),
          ),
        ),
      ),
    );
  }
}
