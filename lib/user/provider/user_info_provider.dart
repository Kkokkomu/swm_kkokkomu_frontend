import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swm_kkokkomu_frontend/common/const/data.dart';
import 'package:swm_kkokkomu_frontend/common/secure_storage/secure_storage.dart';
import 'package:swm_kkokkomu_frontend/user/model/user_model.dart';
import 'package:uuid/uuid.dart';

final userInfoProvider =
    StateNotifierProvider<UserInfoStateNotifier, UserModelBase?>(
  (ref) {
    final storage = ref.watch(secureStorageProvider);

    return UserInfoStateNotifier(
      storage: storage,
    );
  },
);

class UserInfoStateNotifier extends StateNotifier<UserModelBase?> {
  final FlutterSecureStorage storage;

  UserInfoStateNotifier({
    required this.storage,
  }) : super(UserModelLoading()) {
    getInfo();
  }

  Future<void> getInfo() async {
    String? deviceID = await storage.read(key: DEVICE_ID);

    if (deviceID == null) {
      const uuid = Uuid();
      deviceID = uuid.v4();
      await storage.write(key: DEVICE_ID, value: deviceID);
    }

    state = UserModel(id: deviceID);
  }
}
