import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import 'cl_entities.dart';
import 'gallery_group.dart';

enum GroupMethod {
  none,
  byOriginalDate;

  String get label =>
      switch (this) { none => 'None', byOriginalDate => 'Original Date' };
}

@immutable
class EntityGrouper {
  const EntityGrouper({
    required this.entities,
    this.method = GroupMethod.none,
    this.columns = 3,
  });

  final GroupMethod method;
  final int columns;
  final List<CLEntityViewerMixin> entities;

  EntityGrouper copyWith({
    GroupMethod? method,
    int? columns,
    List<CLEntityViewerMixin>? entities,
  }) {
    return EntityGrouper(
      method: method ?? this.method,
      columns: columns ?? this.columns,
      entities: entities ?? this.entities,
    );
  }

  @override
  String toString() =>
      'GroupBy(method: $method, columns: $columns, entities: $entities)';

  @override
  bool operator ==(covariant EntityGrouper other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.method == method &&
        other.columns == columns &&
        listEquals(other.entities, entities);
  }

  @override
  int get hashCode => method.hashCode ^ columns.hashCode ^ entities.hashCode;

  List<GalleryGroupCLEntity<CLEntityViewerMixin>> get getGrouped {
    return switch (method) {
      GroupMethod.none => entities.group(columns),
      GroupMethod.byOriginalDate => entities.groupByTime(columns),
    };
  }
}
