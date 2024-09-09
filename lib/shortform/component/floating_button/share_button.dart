import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';

class ShareButton extends StatelessWidget {
  final String shareUrl;

  const ShareButton({
    super.key,
    required this.shareUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
      ),
      label: '공유',
      onTap: () async {
        // TODO : 공유가 성공적으로 이루어졌는지 확인한 후, api 호출해야 함
        final resp = await Share.shareUri(
          Uri.parse(shareUrl),
        );
        debugPrint('Share response: $resp');
      },
    );
  }
}
