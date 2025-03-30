import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

@immutable
class VideoPlayerState {
  const VideoPlayerState({
    this.path,
    this.controllerAsync = const AsyncValue.loading(),
  });
  final Uri? path;
  final AsyncValue<VideoPlayerController> controllerAsync;

  @override
  bool operator ==(covariant VideoPlayerState other) {
    if (identical(this, other)) return true;

    return other.path == path && other.controllerAsync == controllerAsync;
  }

  @override
  int get hashCode => path.hashCode ^ controllerAsync.hashCode;

  VideoPlayerState copyWith({
    Uri? path,
    AsyncValue<VideoPlayerController>? controllerAsync,
  }) {
    return VideoPlayerState(
      path: path ?? this.path,
      controllerAsync: controllerAsync ?? this.controllerAsync,
    );
  }
}
