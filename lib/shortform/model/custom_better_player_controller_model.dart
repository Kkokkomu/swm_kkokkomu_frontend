import 'package:better_player/better_player.dart';

sealed class CustomBetterPlayerControllerModelBase {}

class CustomBetterPlayerControllerModelLoading
    extends CustomBetterPlayerControllerModelBase {}

class CustomBetterPlayerControllerModelError
    extends CustomBetterPlayerControllerModelBase {
  final String message;

  CustomBetterPlayerControllerModelError(this.message);
}

class CustomBetterPlayerControllerModel
    extends CustomBetterPlayerControllerModelBase {
  final BetterPlayerController controller;

  CustomBetterPlayerControllerModel(this.controller);
}
