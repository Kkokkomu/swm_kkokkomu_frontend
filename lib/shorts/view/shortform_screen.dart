import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swm_kkokkomu_frontend/common/model/offset_pagination_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/component/single_shortform.dart';
import 'package:swm_kkokkomu_frontend/shorts/model/shortform_model.dart';
import 'package:swm_kkokkomu_frontend/shorts/provider/shortform_provider.dart';

class ShortsScreen extends ConsumerStatefulWidget {
  const ShortsScreen({super.key});

  @override
  ConsumerState<ShortsScreen> createState() => _ShortScreenState();
}

class _ShortScreenState extends ConsumerState<ShortsScreen>
    with AutomaticKeepAliveClientMixin<ShortsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final shortForm = ref.watch(shortFormProvider);

    // 완전 처음 로딩일때
    if (shortForm is OffsetPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (shortForm is OffsetPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            shortForm.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(shortFormProvider.notifier).paginate(forceRefetch: true);
            },
            child: const Text(
              '다시시도',
            ),
          ),
        ],
      );
    }

    final cp = shortForm as OffsetPagination<ShortFormModel>;

    return Container(
      color: Colors.black,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: cp.items.length + 1,
        onPageChanged: (value) {
          if (value == cp.items.length - 2) {
            ref.read(shortFormProvider.notifier).paginate(fetchMore: true);
          }
        },
        itemBuilder: (context, index) {
          if (index == cp.items.length) {
            return Center(
              child: cp is OffsetPaginationFetchingMore
                  ? const CircularProgressIndicator()
                  : const Text(
                      '마지막 데이터입니다.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            );
          }

          return SingleShortForm(
            shortForm: cp.items[index],
          );
        },
      ),
    );
  }
}
