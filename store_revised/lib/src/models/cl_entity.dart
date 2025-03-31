import 'dart:convert';

import 'package:meta/meta.dart';

import 'cl_media_type.dart';

typedef ValueGetter<T> = T Function();

@immutable
class CLEntity {
  const CLEntity({
    required this.id,
    required this.isCollection,
    required this.addedDate,
    required this.updatedDate,
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
  });

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
  }) {
    return CLEntity(
      id: id ?? this.id,
      isCollection: isCollection ?? this.isCollection,
      addedDate: addedDate ?? this.addedDate,
      updatedDate: updatedDate ?? this.updatedDate,
      label: label != null ? label() : this.label,
      description: description != null ? description() : this.description,
      parentId: parentId != null ? parentId() : this.parentId,
      fileSize: fileSize != null ? fileSize() : this.fileSize,
      mimeType: mimeType != null ? mimeType() : this.mimeType,
      md5: md5 != null ? md5() : this.md5,
      createDate: createDate != null ? createDate() : this.createDate,
      duration: duration != null ? duration() : this.duration,
      height: height != null ? height() : this.height,
      width: width != null ? width() : this.width,
      type: type != null ? type() : this.type,
      extension: extension != null ? extension() : this.extension,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCollection': isCollection,
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
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CLEntity(id: $id, isCollection: $isCollection, addedDate: $addedDate, updatedDate: $updatedDate, label: $label, description: $description, parentId: $parentId, fileSize: $fileSize, mimeType: $mimeType, md5: $md5, createDate: $createDate, duration: $duration, height: $height, width: $width, type: $type, extension: $extension)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CLEntity &&
        other.id == id &&
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
        other.extension == extension;
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
        extension.hashCode;
  }
}
