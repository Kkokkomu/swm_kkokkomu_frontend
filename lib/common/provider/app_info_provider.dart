import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:swm_kkokkomu_frontend/common/model/app_info_model.dart';
import 'package:swm_kkokkomu_frontend/common/repository/app_info_repository.dart';
import 'package:version/version.dart';

final appInfoProvider =
    StateNotifierProvider<AppInfoStateNotifier, AppInfoModelBase>(
  (ref) {
    final appInfoRepository = ref.watch(appInfoRepositoryProvider);

    return AppInfoStateNotifier(
      appInfoRepository: appInfoRepository,
    );
  },
);

class AppInfoStateNotifier extends StateNotifier<AppInfoModelBase> {
  final AppInfoRepository appInfoRepository;

  AppInfoStateNotifier({
    required this.appInfoRepository,
  }) : super(AppInfoModelLoading()) {
    _getAppInfo();
  }

  void _getAppInfo() async {
    try {
      final currentAppInfo = await PackageInfo.fromPlatform();
      final latestAppInfo = await appInfoRepository.getLatestAppInfo();

      // 앱의 최소 지원 버전보다 낮은 버전의 앱을 사용 중인 경우
      // 앱을 강제로 업데이트하도록 함
      if (Version.parse(latestAppInfo.version) >
          Version.parse(currentAppInfo.version)) {
        state = AppInfoModelForceUpdate(
          currentAppInfo: currentAppInfo,
          latestAppInfo: latestAppInfo,
          storeUrl: latestAppInfo.url,
        );
        return;
      }

      // 강제 업데이트가 필요 없는 경우
      state = AppInfoModel(
        currentAppInfo: currentAppInfo,
        latestAppInfo: latestAppInfo,
      );
    } catch (e) {
      debugPrint(e.toString());
      // 에러가 발생한 경우
      state = AppInfoModelError(e.toString());
    }
  }
}
