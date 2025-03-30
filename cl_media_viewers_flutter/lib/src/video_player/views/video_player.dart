import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/video_player_state.dart';

import 'get_video_controller.dart';
import 'video_layer.dart';

enum PlayerServices { player, controlMenu, playStateBuilder }

class VideoPlayer extends StatelessWidget {
  const VideoPlayer({
    required this.uri,
    required this.autoStart,
    required this.autoPlay,
    required this.isLocked,
    required this.placeHolder,
    required this.errorBuilder,
    required this.loadingBuilder,
    super.key,
    this.onLockPage,
  });
  final Uri uri;
  final bool autoStart;
  final bool autoPlay;
  final void Function({required bool lock})? onLockPage;
  final bool isLocked;

  final Widget? placeHolder;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;

  @override
  Widget build(BuildContext context) {
    /* if (uri.scheme != 'file') {
      log("VideoPlayer can't play $uri");
      return Center(
        child: SizedBox.square(
          dimension: 64,
          child: BrokenImage.show(),
        ),
      );
    } */

    return GetVideoControllerWithState(
      builder: (
        VideoPlayerState state,
        VideoPlayerController controller, {
        required Future<void> Function(Uri uri, {required bool autoPlay})?
            onSetVideo,
        Future<void> Function()? onResetVideo,
      }) {
        if (onSetVideo != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (context.mounted && autoStart) {
              await onSetVideo(uri, autoPlay: autoPlay);
            }
          });
        }
        if (state.path == uri) {
          return VideoLayer(
            controller: controller,
          );
        } else {
          return placeHolder ?? Container();
        }
      },
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
    );
  }
}
