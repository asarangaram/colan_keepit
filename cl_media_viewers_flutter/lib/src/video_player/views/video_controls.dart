import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../builders/video_controls_view.dart';
import '../models/video_player_state.dart';
import 'get_video_controller.dart';

class VideoDefaultControls extends StatelessWidget {
  const VideoDefaultControls({
    required this.uri,
    required this.errorBuilder,
    required this.loadingBuilder,
    super.key,
  });
  final Uri uri;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;

  @override
  Widget build(
    BuildContext context,
  ) {
    return GetVideoControllerWithState(
      builder: (
        VideoPlayerState state,
        VideoPlayerController controller, {
        required Future<void> Function(Uri uri, {required bool autoPlay})?
            onSetVideo,
        Future<void> Function()? onResetVideo,
      }) {
        if (state.path == uri) {
          return VideoControlsView(
            controller: controller,
            onResetVideo: onResetVideo,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      errorBuilder: (message, e) {
        return const SizedBox.shrink();
      },
      loadingBuilder: SizedBox.shrink,
    );
  }
}
