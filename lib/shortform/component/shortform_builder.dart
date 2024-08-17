import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';

Widget buildSingleShortForm(
    BuildContext context, int index, ShortFormModel shortFormModel) {
  final newsId = shortFormModel.shortformList?.id;
  final shortFormUrl = shortFormModel.shortformList?.shortformUrl;

  if (newsId == null || shortFormUrl == null) {
    print('newsId or shortFormUrl is null');

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '비디오 에러 발생\n다음 비디오로 넘어가주세요.',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  return SingleShortForm(
    newsId: newsId,
    shortFormUrl: shortFormUrl,
  );
}
