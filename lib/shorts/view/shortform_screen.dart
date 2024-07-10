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
        allowImplicitScrolling: true,
        physics: const CustomPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: cp.items.length + 1,
        onPageChanged: (value) {
          if (value == cp.items.length - 2) {
            ref.read(shortFormProvider.notifier).paginate(fetchMore: true);
          }
        },
        itemBuilder: (context, index) {
          if (index == cp.items.length) {
            if (cp is OffsetPaginationFetchingMore) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (cp is OffsetPaginationFetchingMoreError) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (cp as OffsetPaginationFetchingMoreError).message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(shortFormProvider.notifier)
                          .paginate(fetchMore: true);
                    },
                    child: const Text(
                      '다시시도',
                    ),
                  ),
                ],
              );
            }

            return const Center(
              child: Text(
                '더 가져올 데이터가 없습니다.',
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

class CustomPhysics extends ScrollPhysics {
  const CustomPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50,
        stiffness: 100,
        damping: 1,
      );
}
