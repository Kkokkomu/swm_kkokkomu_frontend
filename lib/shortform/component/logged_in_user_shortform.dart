import 'package:flutter/material.dart';
import 'package:swm_kkokkomu_frontend/common/component/offset_pagination_page_view.dart';
import 'package:swm_kkokkomu_frontend/shortform/component/shortform_builder.dart';
import 'package:swm_kkokkomu_frontend/shortform/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';

class LoggedInUserShortform extends StatelessWidget {
  const LoggedInUserShortform({super.key});

  @override
  Widget build(BuildContext context) {
    return OffsetPaginationPageView<ShortFormModel>(
      provider: loggedInUserShortFormProvider,
      itemBuilder: buildSingleShortForm,
    );
  }
}
