import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/logged_in_user_shortform_provider.dart';

class LoggedInUserShortform extends ConsumerWidget {
  const LoggedInUserShortform({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedInUserShortForms = ref.watch(loggedInUserShortFormProvider);

    return const Placeholder();
  }
}
