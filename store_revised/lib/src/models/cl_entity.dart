import 'dart:convert';

import 'package:cl_entity_viewers/cl_entity_models.dart';
import 'package:meta/meta.dart';

import 'cl_media_type.dart';

typedef ValueGetter<T> = T Function();

@immutable
class CLEntity implements CLEntityViewerMixin {
  CLEntity({
    required this.id,
    required this.isCollection,
    required this.addedDate,
    required this.updatedDate,
    required this.isDeleted,
    required this.serverId,
    this.label,
    this.description,
    this.parentId,
    this.fileSize,
    this.mimeType,
    this.md5,
    this.createDate,
    this.duration,
    this.height,
    this.width,
    this.type,
    this.extension,
  }) {
    if (isCollection) {
      if (label == null) {
        throw Exception('Collection must have label');
      }
    } else {
      if (md5 == null) {
        throw Exception('media must have md5');
      }
      if (fileSize == null) {
        throw Exception('media must have fileSize');
      }
      if (mimeType == null) {
        throw Exception('media must have mimeType');
      }
      if (extension == null) {
        throw Exception('media must have extension');
      }
      if (type == null) {
        throw Exception('media must have type');
      } else {
        if (type == CLMediaType.image || type == CLMediaType.video) {
          if (height == null) {
            throw Exception('${type!.name} must have height');
          }
          if (width == null) {
            throw Exception('${type!.name} must have width');
          }
        }
        if (type == CLMediaType.audio || type == CLMediaType.video) {
          if (duration == null) {
            throw Exception('${type!.name}  must have duration');
          }
        }
      }
    }
  }

  factory CLEntity.fromMap(Map<String, dynamic> map) {
    return CLEntity(
      id: map['id'] as int,
      isCollection: ((map['isCollection'] ?? 0) as int) != 0,
      addedDate: DateTime.fromMillisecondsSinceEpoch(map['addedDate'] as int),
      updatedDate:
          DateTime.fromMillisecondsSinceEpoch(map['updatedDate'] as int),
      label: map['label'] as String?,
      description: map['description'] as String?,
      parentId: map['parentId'] as int?,
      fileSize: map['fileSize'] as int?,
      mimeType: map['mimeType'] as String?,
      md5: map['md5'] as String?,
      createDate: map['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int)
          : null,
      duration: map['duration'] as double?,
      height: map['height'] as int?,
      width: map['width'] as int?,
      type: map['type'] != null
          ? CLMediaType.fromMap(map['type'] as String)
          : null,
      extension: map['extension'] as String?,
      isDeleted: ((map['isDeleted'] ?? 0) as int) != 0,
      serverId: map['serverId'] as int?,
    );
  }

  factory CLEntity.fromJson(String source) =>
      CLEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  final int id;
  final bool isCollection;
  final DateTime addedDate;
  final DateTime updatedDate;
  final String? label;
  final String? description;
  final int? parentId;
  final int? fileSize;
  final String? mimeType;
  final String? md5;
  final DateTime? createDate;
  final double? duration;
  final int? height;
  final int? width;
  final CLMediaType? type;
  final String? extension;
  final bool isDeleted;
  final int? serverId;

  CLEntity copyWith({
    int? id,
    bool? isCollection,
    DateTime? addedDate,
    DateTime? updatedDate,
    ValueGetter<String?>? label,
    ValueGetter<String?>? description,
    ValueGetter<int?>? parentId,
    ValueGetter<int?>? fileSize,
    ValueGetter<String?>? mimeType,
    ValueGetter<String?>? md5,
    ValueGetter<DateTime?>? createDate,
    ValueGetter<double?>? duration,
    ValueGetter<int?>? height,
    ValueGetter<int?>? width,
    ValueGetter<CLMediaType?>? type,
    ValueGetter<String?>? extension,
    bool? isDeleted,
    ValueGetter<int?>? serverId,
  }) {
    return CLEntity(
      id: id ?? this.id,
      isCollection: isCollection ?? this.isCollection,
      addedDate: addedDate ?? this.addedDate,
      updatedDate: updatedDate ?? this.updatedDate,
      label: label != null ? label.call() : this.label,
      description: description != null ? description.call() : this.description,
      parentId: parentId != null ? parentId.call() : this.parentId,
      fileSize: fileSize != null ? fileSize.call() : this.fileSize,
      mimeType: mimeType != null ? mimeType.call() : this.mimeType,
      md5: md5 != null ? md5.call() : this.md5,
      createDate: createDate != null ? createDate.call() : this.createDate,
      duration: duration != null ? duration.call() : this.duration,
      height: height != null ? height.call() : this.height,
      width: width != null ? width.call() : this.width,
      type: type != null ? type.call() : this.type,
      extension: extension != null ? extension.call() : this.extension,
      isDeleted: isDeleted ?? this.isDeleted,
      serverId: serverId != null ? serverId.call() : this.serverId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCollection': isCollection ? 1 : 0,
      'addedDate': addedDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
      'label': label,
      'description': description,
      'parentId': parentId,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'md5': md5,
      'createDate': createDate?.millisecondsSinceEpoch,
      'duration': duration,
      'height': height,
      'width': width,
      'type': type?.toMap(),
      'extension': extension,
      'isDeleted': isDeleted ? 1 : 0,
      'serverId': serverId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CLEntity(id: $id, isCollection: $isCollection, addedDate: $addedDate, updatedDate: $updatedDate, label: $label, description: $description, parentId: $parentId, fileSize: $fileSize, mimeType: $mimeType, md5: $md5, createDate: $createDate, duration: $duration, height: $height, width: $width, type: $type, extension: $extension, isDeleted: $isDeleted, serverId: $serverId)';
  }

  @override
  bool operator ==(covariant CLEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.isCollection == isCollection &&
        other.addedDate == addedDate &&
        other.updatedDate == updatedDate &&
        other.label == label &&
        other.description == description &&
        other.parentId == parentId &&
        other.fileSize == fileSize &&
        other.mimeType == mimeType &&
        other.md5 == md5 &&
        other.createDate == createDate &&
        other.duration == duration &&
        other.height == height &&
        other.width == width &&
        other.type == type &&
        other.extension == extension &&
        other.isDeleted == isDeleted &&
        other.serverId == serverId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        isCollection.hashCode ^
        addedDate.hashCode ^
        updatedDate.hashCode ^
        label.hashCode ^
        description.hashCode ^
        parentId.hashCode ^
        fileSize.hashCode ^
        mimeType.hashCode ^
        md5.hashCode ^
        createDate.hashCode ^
        duration.hashCode ^
        height.hashCode ^
        width.hashCode ^
        type.hashCode ^
        extension.hashCode ^
        isDeleted.hashCode ^
        serverId.hashCode;
  }

  @override
  int? get entityId => id;

  @override
  bool get isLocal => serverId == null;

  @override
  bool get isRemote => serverId != null;

  @override
  bool get isMarkedDeleted => isDeleted;

  @override
  DateTime get sortDate => createDate ?? updatedDate;
}
