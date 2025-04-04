import 'package:cl_media_viewers_flutter/cl_media_viewers_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:server/server.dart';

import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:store_revised/store_revised.dart';

import '../common/models/cl_colors.dart';
import '../common/models/cl_icons.dart';
import '../common/models/ext_color.dart';

class MediaPreviewWithOverlays extends StatelessWidget {
  const MediaPreviewWithOverlays({
    required this.media,
    required this.parentIdentifier,
    super.key,
  });

  final CLEntity media;
  final String parentIdentifier;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$parentIdentifier /entity/${media.id}',
      child: Tooltip(
        message:
            "${media.label ?? "Unnamed"}${media.description == null ? "" : "\n${media.description}"}",
        child: Stack(
          children: [
            MediaThumbnail(
              media: media,
              overlays: [
                /* OverlayWidgets(
                  heightFactor: 0.2,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.none,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: ShadTheme.of(context)
                        .colorScheme
                        .foreground
                        .withValues(alpha: 0.5),
                    child: Text(
                      media.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ShadTheme.of(context).textTheme.small.copyWith(
                            color: ShadTheme.of(context).colorScheme.background,
                          ),
                    ),
                  ),
                ), */
                if (media.serverId != null)
                  OverlayWidgets.dimension(
                    alignment: Alignment.bottomRight,
                    sizeFactor: 0.15,
                    child: ShadAvatar(
                      'assets/icon/cloud_on_lan_128px_color.png',
                      backgroundColor: ShadTheme.of(context)
                          .colorScheme
                          .background
                          .withValues(alpha: 0.7),
                    ),
                  ),
                /* if (media.pin != null)
                  OverlayWidgets.dimension(
                    alignment: Alignment.bottomRight,
                    sizeFactor: 0.15,
                    child: FutureBuilder(
                      future: theStore.albumManager.isPinBroken(media.pin),
                      builder: (context, snapshot) {
                        return Transform.rotate(
                          angle: math.pi / 4,
                          child: CLIcon.veryLarge(
                            snapshot.data ?? false
                                ? clIcons.brokenPin
                                : clIcons.pinned,
                            color: snapshot.data ?? false
                                ? Colors.red
                                : const Color.fromARGB(255, 33, 243, 47),
                          ),
                        );
                      },
                    ),
                  ), */
                if (media.type == CLMediaType.video)
                  OverlayWidgets.dimension(
                    alignment: Alignment.center,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Theme.of(context).colorScheme.onSurface.withAlpha(
                                  192,
                                ), // Color for the circular container
                      ),
                      child: Icon(
                        clIcons.playerPlay,
                        color: const DefaultCLColors()
                            .iconColorTransparent, //FIXTHIS: CLTheme.of(context).colors.iconColorTransparent,
                      ),
                    ),
                  ),
                /* if (media.isMediaCached && media.hasServerUID)
                  OverlayWidgets.dimension(
                    alignment: Alignment.topLeft,
                    sizeFactor: 0.15,
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ), */
              ],
            ),
            Positioned(
              bottom: 4,
              left: 4,
              right: 4,
              child: Text(
                media.label ?? 'Unnamed',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ShadTheme.of(context).textTheme.muted.copyWith(
                      color: ShadTheme.of(context)
                          .textTheme
                          .muted
                          .color
                          ?.increaseBrightness(0.4),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaThumbnail extends ConsumerWidget {
  const MediaThumbnail({
    required this.media,
    this.overlays,
    super.key,
  });
  final CLEntity media;
  final List<OverlayWidgets>? overlays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(serverProvider);
    final uri = Uri.parse(
      server.identity!.getEndpointURI(media.previewEndPoint!).toString(),
    );

    return ImageViewer.basic(
      uri: uri,
      fit: BoxFit.cover,
      overlays: overlays,
    );
  }
}

extension ServerPathExtOnCLMedia on CLEntity {
  String? get createEndPoint => '/entity';
  String? get updateEndPoint => '/entity/$id';
  String? get previewEndPoint => isCollection ? null : '/entity/$id/preview';
  String? get mediaDownloadEndPoint =>
      isCollection ? null : '/entity/$id/download';
  String? get entityViewEndPoint => isCollection
      ? null
      : (type == CLMediaType.video)
          ? '/entity/$id/stream/m3u8'
          : '/entity/$id/download';
}
