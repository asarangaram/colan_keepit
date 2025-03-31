import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:store_revised/store_revised.dart';

@immutable
class Pagination {
  const Pagination({
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
  });

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      currentPage: map['currentPage'] as int,
      perPage: map['perPage'] as int,
      totalPages: map['totalPages'] as int,
    );
  }

  factory Pagination.fromJson(String source) =>
      Pagination.fromMap(json.decode(source) as Map<String, dynamic>);
  final int currentPage;
  final int perPage;

  final int totalPages;

  Pagination copyWith({
    int? currentPage,
    int? perPage,
    int? totalPages,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentPage': currentPage,
      'perPage': perPage,
      'totalPages': totalPages,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Pagination(currentPage: $currentPage, perPage: $perPage, totalPages: $totalPages)';
  }

  @override
  bool operator ==(covariant Pagination other) {
    if (identical(this, other)) return true;

    return other.currentPage == currentPage &&
        other.perPage == perPage &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^ perPage.hashCode ^ totalPages.hashCode;
  }

  bool get hasNext => currentPage < totalPages;
}

@immutable
class MetaInfo {
  const MetaInfo({
    required this.currentVersion,
    required this.lastSyncedVersion,
    required this.latestVersion,
    required this.pagination,
    required this.totalItem,
  });

  factory MetaInfo.fromMap(Map<String, dynamic> map) {
    return MetaInfo(
      currentVersion: (map['currentVersion'] ?? 0) as int,
      lastSyncedVersion: (map['lastSyncedVersion'] ?? 0) as int,
      latestVersion: (map['latestVersion'] ?? 0) as int,
      pagination: Pagination.fromMap(map['pagination'] as Map<String, dynamic>),
      totalItem: (map['totalItem'] ?? 0) as int,
    );
  }

  factory MetaInfo.fromJson(String source) =>
      MetaInfo.fromMap(json.decode(source) as Map<String, dynamic>);
  final int currentVersion;
  final int lastSyncedVersion;
  final int latestVersion;
  final Pagination pagination;
  final int totalItem;

  MetaInfo copyWith({
    int? currentVersion,
    int? lastSyncedVersion,
    int? latestVersion,
    Pagination? pagination,
    int? totalItem,
  }) {
    return MetaInfo(
      currentVersion: currentVersion ?? this.currentVersion,
      lastSyncedVersion: lastSyncedVersion ?? this.lastSyncedVersion,
      latestVersion: latestVersion ?? this.latestVersion,
      pagination: pagination ?? this.pagination,
      totalItem: totalItem ?? this.totalItem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentVersion': currentVersion,
      'lastSyncedVersion': lastSyncedVersion,
      'latestVersion': latestVersion,
      'pagination': pagination.toMap(),
      'totalItem': totalItem,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MetaInfo(currentVersion: $currentVersion, lastSyncedVersion: $lastSyncedVersion, latestVersion: $latestVersion, pagination: $pagination, totalItem: $totalItem)';
  }

  @override
  bool operator ==(covariant MetaInfo other) {
    if (identical(this, other)) return true;

    return other.currentVersion == currentVersion &&
        other.lastSyncedVersion == lastSyncedVersion &&
        other.latestVersion == latestVersion &&
        other.pagination == pagination &&
        other.totalItem == totalItem;
  }

  @override
  int get hashCode {
    return currentVersion.hashCode ^
        lastSyncedVersion.hashCode ^
        latestVersion.hashCode ^
        pagination.hashCode ^
        totalItem.hashCode;
  }
}

@immutable
class ServerMedia {
  const ServerMedia({
    required this.items,
    required this.metaInfo,
    this.isLoading = false,
  });

  factory ServerMedia.fromMap(Map<String, dynamic> map) {
    return ServerMedia(
      items: List<CLEntity>.from(
        (map['items'] as Iterable<dynamic>).map<CLEntity>(
          (x) {
            return CLEntity.fromMap(x as Map<String, dynamic>);
          },
        ),
      ),
      metaInfo: MetaInfo.fromMap(map['metaInfo'] as Map<String, dynamic>),
    );
  }

  factory ServerMedia.fromJson(String source) =>
      ServerMedia.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ServerMedia.reset(int perPage) {
    return ServerMedia(
      items: const [],
      metaInfo: MetaInfo(
        currentVersion: 0,
        lastSyncedVersion: 0,
        latestVersion: 0,
        totalItem: 0,
        pagination: Pagination(
          currentPage: 0,
          perPage: perPage,
          totalPages: 0,
        ),
      ),
    );
  }
  final List<CLEntity> items;
  final MetaInfo metaInfo;
  final bool isLoading;

  ServerMedia copyWith({
    List<CLEntity>? items,
    MetaInfo? metaInfo,
    bool? isLoading,
  }) {
    return ServerMedia(
      items: items ?? this.items,
      metaInfo: metaInfo ?? this.metaInfo,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'metaInfo': metaInfo.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ServerMedia(items: $items, metaInfo: $metaInfo, isLoading: $isLoading)';

  @override
  bool operator ==(covariant ServerMedia other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.items, items) &&
        other.metaInfo == metaInfo &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => items.hashCode ^ metaInfo.hashCode ^ isLoading.hashCode;
}
