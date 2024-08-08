import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/shortform/provider/guest_user_shortform_provider.dart';

class GuestUserShortform extends ConsumerWidget {
  const GuestUserShortform({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestUserShortForms = ref.watch(guestUserShortFormProvider);

    return const Placeholder();
  }
}
