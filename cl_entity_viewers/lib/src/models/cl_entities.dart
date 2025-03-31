import 'ext_datetime.dart';
import 'ext_list.dart';

import 'gallery_group.dart';

abstract class CLEntityViewerMixin {
  bool get isRemote;
  bool get isLocal;
  /* bool get isSynced; */
  bool get isMarkedDeleted;
  /* bool get isMarkedEditted;
  bool get isMarkedForUpload; */

  int? get entityId;
  DateTime get sortDate;
}

extension Filter on List<CLEntityViewerMixin> {
  Map<String, List<CLEntityViewerMixin>> filterByDate() {
    final filterredMedia = <String, List<CLEntityViewerMixin>>{};
    final noDate = <CLEntityViewerMixin>[];
    for (final entry in this) {
      final String formattedDate;
      formattedDate = entry.sortDate.toDisplayFormat(dataOnly: true);
      if (!filterredMedia.containsKey(formattedDate)) {
        filterredMedia[formattedDate] = [];
      }
      filterredMedia[formattedDate]!.add(entry);
    }
    if (noDate.isNotEmpty) {
      filterredMedia['No Date'] = noDate;
    }

    return filterredMedia;
  }

  List<GalleryGroupCLEntity<CLEntityViewerMixin>> groupByTime(int columns) {
    final galleryGroups = <GalleryGroupCLEntity<CLEntityViewerMixin>>[];

    for (final entry in filterByDate().entries) {
      if (entry.value.length > columns) {
        final groups = entry.value.convertTo2D(columns);

        for (final (index, group) in groups.indexed) {
          galleryGroups.add(
            GalleryGroupCLEntity(
              group,
              label: (index == 0) ? entry.key : null,
              groupIdentifier: entry.key,
              chunkIdentifier: '${entry.key} $index',
            ),
          );
        }
      } else {
        galleryGroups.add(
          GalleryGroupCLEntity(
            entry.value,
            label: entry.key,
            groupIdentifier: entry.key,
            chunkIdentifier: entry.key,
          ),
        );
      }
    }
    return galleryGroups;
  }

  List<GalleryGroupCLEntity<CLEntityViewerMixin>> group(int columns) {
    final galleryGroups = <GalleryGroupCLEntity<CLEntityViewerMixin>>[];

    for (final rows in convertTo2D(columns)) {
      galleryGroups.add(
        GalleryGroupCLEntity(
          rows,
          label: null,
          groupIdentifier: 'CLEntity',
          chunkIdentifier: 'CLEntity',
        ),
      );
    }
    return galleryGroups;
  }
}
