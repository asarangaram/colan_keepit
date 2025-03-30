import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../models/video_player_state.dart';
import '../providers/video_player_state.dart';

class VideoControls {
  VideoControls({required this.play, required this.pause});
  final Future<void> Function() play;
  final Future<void> Function() pause;
}

class GetVideoController extends ConsumerWidget {
  const GetVideoController({
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
    super.key,
  });
  final Widget Function(
    // VideoPlayerState state,
    VideoControls controller,
  ) builder;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoPlayerStateProvider);
    return state.controllerAsync.when(
      data: (controller) {
        return builder(
          VideoControls(
            pause: controller.pause,
            play: controller.play,
          ),
        );
      },
      error: errorBuilder,
      loading: loadingBuilder,
    );
  }
}

class GetVideoControllerWithState extends ConsumerWidget {
  const GetVideoControllerWithState({
    required this.builder,
    required this.errorBuilder,
    required this.loadingBuilder,
    super.key,
  });
  final Widget Function(
    VideoPlayerState state,
    VideoPlayerController controller, {
    required Future<void> Function(Uri uri, {required bool autoPlay})?
        onSetVideo,
    Future<void> Function()? onResetVideo,
  }) builder;
  final Widget Function(Object, StackTrace) errorBuilder;
  final Widget Function() loadingBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoPlayerStateProvider);
    return state.controllerAsync.when(
      data: (controller) => builder(
        state,
        controller,
        onResetVideo: () async => ref
            .read(videoPlayerStateProvider.notifier)
            .resetVideo(forced: true),
        onSetVideo: (Uri uri, {required bool autoPlay}) async =>
            ref.read(videoPlayerStateProvider.notifier).setVideo(
                  uri,
                  autoPlay: autoPlay,
                ),
      ),
      error: errorBuilder,
      loading: loadingBuilder,
    );
  }
}
