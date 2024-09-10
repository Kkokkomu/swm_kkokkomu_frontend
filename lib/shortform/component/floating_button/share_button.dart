import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/custom_floating_button.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/post_news_id_body.dart';
import 'package:swm_kkokkomu_frontend/shortform/repository/shortform_logging_repository.dart';

class ShareButton extends ConsumerWidget {
  final int newsId;
  final String shareUrl;

  const ShareButton({
    super.key,
    required this.newsId,
    required this.shareUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomFloatingButton(
      icon: const Icon(
        Icons.share,
        color: Colors.white,
      ),
      label: '공유',
      onTap: () async {
        final resp = await Share.shareUri(
          Uri.parse(shareUrl),
        );

        if (resp.status == ShareResultStatus.success) {
          ref
              .read(shortFormLoggingRepositoryProvider)
              .logNewsShare(body: PostNewsIdBody(newsId: newsId));
        }
      },
    );
  }
}
