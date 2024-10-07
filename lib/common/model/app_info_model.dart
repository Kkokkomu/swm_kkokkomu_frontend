import 'package:json_annotation/json_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_info_model.g.dart';

sealed class AppInfoModelBase {}

class AppInfoModelLoading extends AppInfoModelBase {}

class AppInfoModelError extends AppInfoModelBase {
  final String message;

  AppInfoModelError(this.message);
}

class AppInfoModelOffline extends AppInfoModelBase {}

class AppInfoModelForceUpdate extends AppInfoModelBase {
  final PackageInfo currentAppInfo;
  final LatestAppInfo latestAppInfo;
  final String storeUrl;

  AppInfoModelForceUpdate({
    required this.currentAppInfo,
    required this.latestAppInfo,
    required this.storeUrl,
  });
}

class AppInfoModel extends AppInfoModelBase {
  final PackageInfo currentAppInfo;
  final LatestAppInfo latestAppInfo;

  AppInfoModel({
    required this.currentAppInfo,
    required this.latestAppInfo,
  });
}

@JsonSerializable()
class LatestAppInfo {
  final String version;
  final String minVersion;
  final String url;
  final List<String> blacklistedVersions;
  final bool isOnline;

  LatestAppInfo({
    required this.version,
    required this.minVersion,
    required this.url,
    required this.blacklistedVersions,
    required this.isOnline,
  });

  factory LatestAppInfo.fromJson(Map<String, dynamic> json) =>
      _$LatestAppInfoFromJson(json);
}
