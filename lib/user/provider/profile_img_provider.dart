// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';

// final profileImgProvider =
//     StateNotifierProvider.autoDispose<ProfileImgStateNotifier, File?>(
//   (ref) => ProfileImgStateNotifier(),
// );

// class ProfileImgStateNotifier extends StateNotifier<File?> {
//   final ImagePicker _picker = ImagePicker();

//   ProfileImgStateNotifier() : super(null);

//   Future<File?> getProfileImgFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     // 이미지를 선택하지 않았다면 종료
//     if (pickedFile == null) {
//       return null;
//     }

//     state = File(pickedFile.path);
//     return state;
//   }

//   Future<File?> getProfileImgFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

//     // 이미지를 선택하지 않았다면 종료
//     if (pickedFile == null) {
//       return null;
//     }

//     state = File(pickedFile.path);
//     return state;
//   }
// }
