enum CLMediaType {
  text,
  image,
  video,
  url,
  audio,
  file;

  factory CLMediaType.fromMap(String name) {
    return CLMediaType.values.asNameMap()[name]!;
  }

  bool get isFile => switch (this) { text => false, url => false, _ => true };

  String toMap() => name;
}
