class File {
  final String? mimeType;

  File({
    required this.mimeType,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      mimeType: json.containsKey('mimeType') ? json['mimeType'] : null,
    );
  }
}
