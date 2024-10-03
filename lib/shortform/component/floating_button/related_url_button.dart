import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/gen/assets.gen.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';
import 'package:url_launcher/url_launcher.dart';

class RelatedUrlButton extends StatelessWidget {
  final String shortFormRelatedURL;

  const RelatedUrlButton({
    super.key,
    required this.shortFormRelatedURL,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      width: 64.0,
      height: 64.0,
      icon: Assets.icons.svg.icMore.svg(),
      label: '관련기사',
      onTap: () async {
        final url = await canLaunchUrl(Uri.parse(shortFormRelatedURL))
            ? shortFormRelatedURL
            : Constants.relatedUrlOnError;

        launchUrl(
          Uri.parse(url),
        );
      },
    );
  }
}
